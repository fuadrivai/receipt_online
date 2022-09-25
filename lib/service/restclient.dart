import 'package:dio/dio.dart';
import 'package:receipt_online_shop/screen/expedition/data/expedition.dart';
import 'package:retrofit/http.dart';

part 'restclient.g.dart';

@RestApi()
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

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
