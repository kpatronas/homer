# homer
Print stats of each subdir of /home (or any path)

## Examples
Local execution

```
sudo ./homer.sh

Hostname  Partition                   Part-Size  Dir-Size  Dir-Perc  Dir-Name                 Last-Modified
server01  /dev/mapper/rootvg-home_lv  19G        7.9G      39.00%    jack                     2024-03-08
server01  /dev/mapper/rootvg-home_lv  19G        1.8G      8.00%     joe                      2023-05-12
server01  /dev/mapper/rootvg-home_lv  19G        697M      3.00%     maria                    2019-07-31
server01  /dev/mapper/rootvg-home_lv  19G        232M      1.00%     helen                    2020-10-29
```

Remote execution

```
ssh root@gserver01 'bash -s' < ./homer.sh
root@server01's password:

Hostname  Partition                   Part-Size  Dir-Size  Dir-Perc  Dir-Name                 Last-Modified
server01  /dev/mapper/rootvg-home_lv  19G        7.9G      39.00%    jack                     2024-03-08
server01  /dev/mapper/rootvg-home_lv  19G        1.8G      8.00%     joe                      2023-05-12
server01  /dev/mapper/rootvg-home_lv  19G        697M      3.00%     maria                    2019-07-31
server01  /dev/mapper/rootvg-home_lv  19G        232M      1.00%     helen                    2020-10-29
```

Optional parameters

-h: Dont show headers

-d: define home path (or any path)
