import os
from dbt.cli.main import dbtRunner, dbtRunnerResult


def build_tables() -> None:
    dbt = dbtRunner()
    os.environ["DBT_PROJECT_DIR"] = "dbt_project/"

    cli_args = ["build"]

    os.makedirs(os.path.dirname("data/dbt.db"), exist_ok=True)
    res: dbtRunnerResult = dbt.invoke(cli_args)

    return
