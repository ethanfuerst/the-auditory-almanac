import os
import duckdb
import pandas as pd
import re

DUCKDB_DB_FILE = "data/dbt.db"


def to_title_case(input_string) -> str:
    lowercase_words = ["of", "and"]
    spaced_string = input_string.replace("_", " ")
    spaced_string = re.sub(r"([A-Z])", r" \1", spaced_string)
    title_cased = " ".join(
        [
            word if word in lowercase_words else word.capitalize()
            for word in spaced_string.split()
        ]
    )
    return title_cased[0].upper() + title_cased[1:]


def linkify_tracks(df) -> pd.DataFrame:
    if "track" in df.columns and "spotify_link" in df.columns:
        df["track"] = df.apply(
            lambda row: f'<a href="{row["spotify_link"]}" target="_blank">{row["track"]}</a>',
            axis=1,
        )
    return df


def query_and_clean_df(query) -> pd.DataFrame:
    con = duckdb.connect(DUCKDB_DB_FILE)
    df = con.execute(query).df()
    con.close()
    df = linkify_tracks(df)
    df.columns = [to_title_case(col) for col in df.columns]
    if "Spotify Link" in df.columns:
        df = df.drop(columns=["Spotify Link"])
    return df


def top_100_songs() -> pd.DataFrame:
    return query_and_clean_df("select * from the_auditory_almanac.top_100")


def top_binged_songs() -> pd.DataFrame:
    return query_and_clean_df("select * from the_auditory_almanac.top_binged")
