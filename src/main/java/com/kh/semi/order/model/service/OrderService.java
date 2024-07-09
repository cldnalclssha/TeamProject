package com.kh.semi.order.model.service;

import java.util.List;

import com.kh.semi.order.model.vo.Order;
import com.kh.semi.order.model.vo.OrdersImg;


public interface OrderService {

	int insertOrder(Order o, OrdersImg oi) throws Exception;

	List<Order> selectOrderList();

	Order selectOrderOne(int orderNo);

	OrdersImg selectOrdersImg(int orderNo);

}
