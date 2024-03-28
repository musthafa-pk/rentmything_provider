class AppUrl{

  // ip address from office network
  static var baseUrl = 'http://192.168.1.12:3005';

  //ip address from my offic lap
  // static var baseUrl = 'http://192.168.1.5:3005';

  //ip address from mobile network
  // static var baseUrl = 'http://192.168.110.96:3005';

  //ip address from hosted network
  // static var baseUrl = 'http://3.109.180.229:3005';

  //auth api
  static String loginApi = '$baseUrl/user/login';


  //user api

  static String userDetails = '$baseUrl/user/userdetails';

  static String userAdd = '$baseUrl/user/usersadd';

  static String userEdit = '$baseUrl/user/editUser';

  static String emailVerifiication = '$baseUrl/user/emailverification';

  //category api

  static String getallCategory = '$baseUrl/categorysub/allcategories';

  static String getCategory = '$baseUrl/categorysub/getcategory';

  static String getSubCategory = '$baseUrl/categorysub/getsubcategory';

  static String getProductByCategory = '$baseUrl/categorysub/productlist';

  //cart & wishlist

  static String wishlistAdd = '$baseUrl/wishlist/wishlistadd';

  static String wishlistget = '$baseUrl/wishlist/getwishlist';

  static String getCart = '$baseUrl/cart/getcart';

  static String addtoCart = '$baseUrl/cart/cartadd';

  //products api

  static String addProduct = '$baseUrl/products/productsadd';

  static String listProducts  = '$baseUrl/products/prodlist';

  static String getProductDetials = '$baseUrl/products/productdetails';

  static String getProductbycatego = '$baseUrl/products/prodcategory';

  //popular products
  static String listPopular = '$baseUrl/products/popularproduct';

  //wishlist
  static String getwishlist = '$baseUrl/wishlist/getwishlist';

  //addtorent
  static String addrentdata = '$baseUrl/rent/addrentdata';
  //rented Data getting
  static String getRentedData = '$baseUrl/rent/renteddata';


}