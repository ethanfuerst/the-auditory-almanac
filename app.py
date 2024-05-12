import os
import duckdb
import fnmatch
import pandas as pd
from flask import Flask, render_template, request, redirect, url_for, flash, session
from werkzeug.utils import secure_filename
from utils.process_data import build_tables
from utils.spotify_connect import top_100_songs, top_binged_songs


app = Flask(__name__)
app.config["UPLOAD_FOLDER"] = "uploads"
app.config["SECRET_KEY"] = os.environ.get("SECRET_KEY", "DEFAULT_FOR_TESTING")


@app.route("/", methods=["GET", "POST"])
def index():
    if request.method != "POST":
        return render_template("index.html")

    if "files" not in request.files:
        flash("No files part")
        return redirect(request.url)

    uploaded_files = request.files.getlist("files")

    if not uploaded_files or uploaded_files[0].filename == "":
        flash("No selected files")
        return redirect(request.url)

    if not any(fnmatch.fnmatch(file.filename, "*.json") for file in uploaded_files):
        flash("No .json files found!")
        return redirect(request.url)

    for file in uploaded_files:
        filename = secure_filename(file.filename)
        file_path = os.path.join(app.config["UPLOAD_FOLDER"], "MyData")
        if not os.path.exists(file_path):
            os.makedirs(file_path)
        file.save(os.path.join(file_path, filename))
        flash("File(s) successfully uploaded", "files_uploaded")

    return redirect(url_for("index"))


@app.route("/process_files")
def process_files():
    build_tables()
    session["FILES_PROCESSED"] = True
    flash("Files processed successfully", "files_processed")
    return redirect(url_for("index"))


@app.route("/create-reports")
def create_reports():
    top_100_songs()
    return redirect(url_for("index"))


@app.route("/view_results")
def view_results():
    top_100 = top_100_songs()
    top_binged = top_binged_songs()
    table_info = (
        {
            "title": "Your Top 100 Songs of All Time",
            "description": "Here's your top 100 songs of all time! Any surprises?",
            "table": top_100.to_html(classes="data", index=False, escape=False),
        },
        {
            "title": "Most Binged Songs",
            "description": "These are the songs you streamed the most frequently throughout the years.",
            "table": top_binged.to_html(classes="data", index=False, escape=False),
        },
    )
    result = render_template("results.html", table_info=table_info)
    session.pop("FILES_PROCESSED", None)
    return result


if __name__ == "__main__":
    app.run(debug=True)
