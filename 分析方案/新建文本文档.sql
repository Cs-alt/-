#统计每天的订单金额，订单总笔数
insert into itcast_shop_bi.app_order_user
select
 null,
 substring(createTime,1,10),
 count(distinct userId) as user_total
from itcast_shop_bi.ods_itheima_orders
where substring(createTime,1,10)='2019-09-05'
group by substring(createTime,1,10);

#统计当天下过订单的不同用户总数
insert into itcast_shop_bi.app_order_total
select
    NULL,
    substring(createTime,1,10),
    sum(realTotalMoney) as total_money,
    count(1) as total_cnt
from itcast_shop_bi.ods_itheima_orders t
where substring(createTime,1,10)='2019-09-05'
group by substring(createTime,1,10);


#统计不同支付方式订单总额和订单笔数分析
insert into itcast_shop_bi.app_order_paytype
select
null,
'2019-09-05',
case when payType=1 then '支付宝'
    when payType=2 then '微信'
    when payType=3 then '信用卡'
    else '其他'
end as payType,
sum(realTotalMoney)as total_money,
count(*)as total_orders
from itcast_shop_bi.ods_itheima_orders
where substring(createTime,1,10)='2019-09-05'
group by payType;


#统计用户订单笔数Top5
alter table itcast_shop_bi.app_order_user_top5 modify dt varchar(20)

insert  into itcast_shop_bi.app_order_user_top5
select
    NULL,
    '2019-09',
    tt.userId,
    tt.userName,
    tt.total_cnt

from (select *, rank() over(order by t.total_cnt desc) as rk
      from (select '2019-09', userId, userName, count(orderId) as total_cnt
            from itcast_shop_bi.ods_itheima_orders
            where substring(createTime, 1, 7) = '2019-09'
            group by userId, userName
           ) t
     )tt
where
  tt.rk <= 5;

