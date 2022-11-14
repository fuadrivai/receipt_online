// ignore_for_file: non_constant_identifier_names

import 'package:dio/dio.dart';
import 'package:receipt_online_shop/model/daily_task.dart';
import 'package:receipt_online_shop/model/lazada/lazada_count.dart';
import 'package:receipt_online_shop/model/receipt.dart';
import 'package:receipt_online_shop/model/transaction_online.dart';
import 'package:receipt_online_shop/screen/expedition/data/expedition.dart';
import 'package:retrofit/http.dart';

import '../model/lazada/full_order.dart';

part 'restclient.g.dart';

@RestApi()
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @POST("shopee-order/rts/{orderSn}")
  Future shopeeRts(@Path() String orderSn);

  @POST("transaction-online")
  Future<TransactionOnline> postTransactionOnline(
      @Body() TransactionOnline dataOnline);

  @GET("lazada/order/{status}/{sorting}")
  Future<List<TransactionOnline>> lazadaGetFullOrder(
      @Path() String status, @Path() String sorting);

  @GET("jd-order")
  Future<TransactionOnline> getJdIdOrderByNo();
  @GET("shopee-order")
  Future<List<TransactionOnline>> getShopeeOrders();

  @GET("shopee-order/order/v2/{orderSn}")
  Future<List<TransactionOnline>> getShopeeOrderByNo(@Path() String orderSn);

  @POST(
      "lazada-order/rts/{tracking_number}/{shipment_provider}/{order_item_ids}")
  Future<dynamic> orderRts(@Path() String tracking_number,
      @Path() String shipment_provider, @Path() List<int>? order_item_ids);

  @GET("lazada-order/count")
  Future<LazadaCount> lazadaGetCount();

  @GET("lazada-order/{orderId}")
  Future<TransactionOnline> getOrder(@Path() String orderId);

  @GET("lazada-order/pending/{sorting}")
  Future<FullOrder> getPendingOrder(@Path() String sorting);

  @GET("lazada-order/rts/{sorting}")
  Future<FullOrder> getRtsOrder(@Path() String sorting);

  @GET("lazada-order/packed/{sorting}")
  Future<FullOrder> getPackedOrder(@Path() String sorting);

  @GET("daily-task/receipt/{id}")
  Future<Receipt> receiptByDailyTaskId(@Path() int id);

  @POST("daily-task/receipt/{id}")
  Future<dynamic> dailyTaskPostReceipt(@Path() int id, @Body() Receipt receipt);

  @DELETE("daily-task/receipt/{number}")
  Future<dynamic> deleteReceipt(@Path() String number);

  @GET("daily-task/current")
  Future<List<DailyTask>> findCurrentDailyTask();

  @GET("daily-task/{id}")
  Future<DailyTask> dailyTaskFindById(@Path() int id);

  @POST("daily-task")
  Future<DailyTask> postDailyTask(@Body() DailyTask dailyTask);

  @GET("expedition")
  Future<List<Expedition>> findAllExpedition();

  @GET("expedition/{id}")
  Future<Expedition> expeditionFindById(@Path() int id);

  @POST("expedition")
  Future<Expedition> postExpedition(@Body() Expedition expedition);

  @PUT("expedition/{id}")
  Future expeditionEdit(@Path() int id, @Body() Expedition cst);

  // @GET("sales/{id}")
  // Future<Salesman> salesmanFindById(@Path() String id);

  // @GET("customer")
  // Future<List<Customer>> findAllCustomer();

  // @GET("customer/{id}")
  // Future<Customer> customerFindById(@Path() String id);

}
