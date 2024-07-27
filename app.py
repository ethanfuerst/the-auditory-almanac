import os
import duckdb
import fnmatch
import pandas as pd
from flask import Flask, render_template, request, redirect, url_for, flash, session
from werkzeug.utils import secure_filename
from utils.process_data import build_tables
from utils.spotify_connect import query_and_clean_df, top_100_songs, top_binged_songs

app = Flask(__name__)
app.config["UPLOAD_FOLDER"] = "uploads"

secret_key = os.environ.get("SECRET_KEY")
if not secret_key:
    raise ValueError(
        "No SECRET_KEY set for Flask application. Did you forget to set it?"
    )
app.config["SECRET_KEY"] = secret_key


@app.route("/")
def index():
    return render_template("index.html")


@app.route("/upload-files", methods=["GET", "POST"])
def upload_files():
    if request.method == "POST":
        uploaded_files = request.files.getlist("files")
        if not uploaded_files:
            flash("No files selected", "error")
            return redirect(url_for("upload_files"))

        if not os.path.exists(app.config["UPLOAD_FOLDER"]):
            os.makedirs(app.config["UPLOAD_FOLDER"])

        for file in uploaded_files:
            if file.filename == "":
                flash("No selected files", "error")
                continue

            filename = secure_filename(file.filename)
            if not filename.endswith(".json"):
                flash(f"Invalid file type for {filename}", "error")
                continue

            file_path = os.path.join(app.config["UPLOAD_FOLDER"], filename)
            try:
                file.save(file_path)
                flash("Files successfully uploaded", "success")
            except Exception as e:
                flash(f"Failed to save file {filename}: {str(e)}", "error")

        return redirect(url_for("upload_files"))

    return render_template("upload-files.html")


@app.route("/process-files")
def process_files():
    try:
        build_tables()
        app.logger.info("Files processed")
        dbt_build_logs = query_and_clean_df(
            "select * from the_auditory_almanac.process_files_log;"
        )
        app.logger.info(f"Data build logs: {dbt_build_logs}")
        session["FILES_PROCESSED"] = True
        flash("Files processed successfully", "files_processed")
    except Exception as e:
        flash(f"Error processing files: {str(e)}", "error")
        return redirect(url_for("upload_files"))

    return redirect(url_for("view_results"))


@app.route("/view-results")
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
    app.run()
