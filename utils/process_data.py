import os
from dbt.cli.main import dbtRunner, dbtRunnerResult


def build_tables() -> None:
    # https://docs.getdbt.com/reference/programmatic-invocations
    dbt = dbtRunner()
    os.environ["DBT_PROJECT_DIR"] = "dbt_project/"
    # same as "--project-dir dbt_project/"

    # check for env vars https://docs.getdbt.com/reference/parsing#known-limitations
    cli_args = ["build"]

    os.makedirs(os.path.dirname("data/dbt.db"), exist_ok=True)
    res: dbtRunnerResult = dbt.invoke(cli_args)
    # log res.result

    return
