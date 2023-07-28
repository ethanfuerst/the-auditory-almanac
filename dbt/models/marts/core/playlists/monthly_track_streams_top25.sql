select *
from {{ ref('int_monthly_track_streams') }}
where 1 = 1
    and play_time_rank <= 25
order by
    month
    , play_time_rank
