### SRIOV setting for 1RU/1cell of ran only
|:-----|:-------|:-------|:-------|:-------|:-------|
| |	ens2f0 |	WPC Port 0 |  WPC Port 1 |	WPC Port 2 |	WPC Port 3 |
|Vf 0 |cu_cp_n2  |	du1_fh1 |  du1_fh2 |  du1_fh3 |  du1_fh4 |
|Vf 1 |cu_up_n3u | du1_arp1 | du1_arp2 | du1_arp3 | du1_arp4 |
|Vf 2	|du1_f1u | mplane | mplane | mplane | mplane |
|Vf 3	|cu_up_f1u | | | | |
|Vf 4	|macvlan | | | | |

| Column 1 | Column 2 | Column 3 |
|----------|----------|----------|
| Row 1    | Cell 2   | Cell 3   |
| Row 2    | Cell 5   | Cell 6   |
| Row 3    | Cell 8   | Cell 9   |
