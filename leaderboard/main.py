import json
import logging
import psycopg2
import os
from flask import Flask, request
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

@app.route("/submit", methods=["POST"])
def submit():
    try:
        record = json.loads(request.data)
    except Exception as e:
        return f"Invalid json: {e}", 400

    if not all(key in record for key in ["final_time", "username", "password"]):
        return "Missing field", 400

    final_time, username, password = record["final_time"], record["username"], record["password"]

    conn = get_db_conn()

    db_record = get_record(conn, username)

    if db_record:
        # 👀
        if password == db_record[3]:
            set_record_time(conn, username, final_time)
            conn.close()
            return "Time updated!", 200
        conn.close()
        return "Password incorrect. (Or user already exists)", 401

    try:
        insert_record(conn, final_time, username, password)
    except Exception as e:
        return e, 400

    conn.close()
    return "Time submitted!", 200

@app.route("/top_ten", methods=["GET"])
def top_ten():
    conn = get_db_conn()
    records = get_top_ten(conn)
    return {record[0]: record[1] for record in records}, 200

@app.route("/time", methods=["GET"])
def time():
    username = request.args.get("username")
    if username == None or len(username) <= 0:
        return "Missing 'username' query parameter", 400

    conn = get_db_conn()

    record = get_record(conn, username)
    if record == None:
        return "Couldn't find user", 400

    return { record[2]: record[1] }, 200
