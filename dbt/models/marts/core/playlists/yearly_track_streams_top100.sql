select *
from {{ ref('int_yearly_track_streams') }}
where 1 = 1
    and play_time_rank <= 25
order by
    year
    , play_time_rank
