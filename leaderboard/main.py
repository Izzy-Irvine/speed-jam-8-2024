import json
import logging
import psycopg2
import os
from flask import Flask, request, Response, jsonify
import sys

app = Flask(__name__)

def get_db_conn():
    return psycopg2.connect(os.environ['PG_CONN_STRING'])

def get_record(conn, username):
    cur = conn.cursor()
    cur.execute("SELECT * FROM record WHERE username = %s", (username,))
    return cur.fetchone()

def set_record_time(conn, username, final_time):
    cur = conn.cursor()
    cur.execute("UPDATE record SET final_time = %s WHERE username = %s", (final_time, username))
    conn.commit()

def insert_record(conn, final_time, username, password):
    cur = conn.cursor()
    cur.execute("INSERT INTO record (final_time, username, password) VALUES (%s, %s, %s)", (final_time, username, password))
    conn.commit()

def get_top_ten(conn):
    cur = conn.cursor()
    cur.execute("SELECT username, final_time FROM record ORDER BY final_time ASC LIMIT 10")
    return cur.fetchall()

def make_response(resp, status):
    r = Response(resp, status)
    r.headers['Access-Control-Allow-Origin'] = '*'
    return r

@app.route("/submit", methods=["POST"])
def submit():
    try:
        record = json.loads(request.data)
    except Exception as e:
        return make_response(f"Invalid json: {e}", 400)

    if not all(key in record for key in ["final_time", "username", "password"]):
        return make_response("Missing field", 400)

    final_time, username, password = record["final_time"], record["username"], record["password"]

    conn = get_db_conn()

    db_record = get_record(conn, username)

    if db_record:
        # 👀
        if password == db_record[3]:
            set_record_time(conn, username, final_time)
            conn.close()
            return make_response("Time updated!", 200)
        conn.close()
        return make_response("Password incorrect. (Or user already exists)", 401)

    try:
        insert_record(conn, final_time, username, password)
    except Exception as e:
        return make_response(e, 400)

    conn.close()
    return make_response("Time submitted!", 200)

@app.route("/top_ten", methods=["GET"])
def top_ten():
    conn = get_db_conn()
    records = get_top_ten(conn)
    return make_response(jsonify({record[0]: record[1] for record in records}), 200)

@app.route("/time", methods=["GET"])
def time():
    username = request.args.get("username")
    if username == None or len(username) <= 0:
        return make_response("Missing 'username' query parameter", 400)

    conn = get_db_conn()

    record = get_record(conn, username)
    if record == None:
        return make_response("Couldn't find user", 400)

    return make_response(jsonify({ record[2]: record[1] }), 200)
