
from flask import Flask, render_template, jsonify
import oracledb

app = Flask(__name__)

# Update these values to match your Oracle installation.
DB_USER = "MYDBMS"
DB_PASSWORD = "Abhishek@12"
DB_DSN = "localhost:1521/XEPDB1"

def get_connection():
    return oracledb.connect(
        user=DB_USER,
        password=DB_PASSWORD,
        dsn=DB_DSN
    )

@app.route("/")
def home():
    return render_template("index.html")

@app.route("/api/medicines")
def get_medicines():
    connection = get_connection()

    try:
        cursor = connection.cursor()
        cursor.execute("""
            SELECT medicine_id, medicine_name, price,
                   stock_quantity, expiry_date
            FROM medicines
            ORDER BY medicine_id
        """)

        rows = cursor.fetchall()

        medicines = [
            {
                "id": row[0],
                "name": row[1],
                "price": float(row[2]),
                "stock": row[3],
                "expiry": row[4].strftime("%Y-%m-%d")
            }
            for row in rows
        ]

        return jsonify(medicines)

    finally:
        connection.close()

if __name__ == "__main__":
    app.run(debug=True)
