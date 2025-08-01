class ApiEndpoints {
  ApiEndpoints._();

  // Timeouts
  static const connectionTimeout = Duration(seconds: 1000);
  static const receiveTimeout = Duration(seconds: 1000);

  // Emulator server
  // static const String serverAddress = "http://10.0.2.2:5050";
  static const String serverAddress = "http://192.168.1.70:5050";

  static const String baseUrl = "$serverAddress/api";

  // Auth
  static const String login = "/users/login";
  static const String register = "/users/signup";
  static const String sendOtp = "/users/forgotPassword";
  static const String verifyOtp = "/users/verify-otp";
  static const String resetPassword = "/users/resetPassword";

  // categories endpoints
  static const String createCategory = "/categories/create";
  static const String getAllCategories = "/categories";

  static String deactivateCategory(String categoryId) =>
      "/categories/category/deactivate/$categoryId";

  static String activateCategory(String categoryId) =>
      "/categories/category/activate/$categoryId";

  static String getCategoryById(String categoryId) =>
      "/categories/category/$categoryId";

  // supplier endpoints
  static const String createSupplier = "/suppliers/create";
  static const String getAllSuppliers = "/suppliers";

  static String getSupplierById(String supplierId) =>
      "/suppliers/supplier/$supplierId";

  static String updateSupplier(String supplierId) =>
      "/suppliers/supplier/update/$supplierId";

  static String deactivateSupplier(String supplierId) =>
      "/suppliers/supplier/deactivate/$supplierId";

  static String activateSupplier(String supplierId) =>
      "/suppliers/supplier/activate/$supplierId";

  // dashboard endpoints
  static const String dashboardOverview = "/dashboard/overview";

  // product endpoints
  static const String createProduct = "/products/create";
  static const String getAllProducts = "/products";

  static String getProductById(String productId) =>
      "/products/product/$productId";

  static String updateProduct(String productId) =>
      "/products/product/update/$productId";

  static String deactivateProduct(String productId) =>
      "/products/product/deactivate/$productId";

  static String activateProduct(String productId) =>
      "/products/product/activate/$productId";

  // stock endpoints
  static const String getAllStock = "/stocks";
  static String getStockHistory(String productId) =>
      "/stocks/history/$productId";

  // Sale endpoints
  static const String createSale = "/sales/create";
  static const String getAllSales = "/sales";

  static String getSaleById(String saleId) => "/sales/sale/$saleId";

  static String cancelSale(String saleId) => "/sales/sale/cancel/$saleId";

  // Profile Endpoints

  static const String getProfile = "/users/me";

  static String updateUserInfo(String userId) =>
      "/users/updateUserInfo/$userId";

  static String updatePassword(String userId) =>
      "/users/updatePassword/$userId";

  static String updateEmail(String userId) => "/users/updateEmail/$userId";

  static String updateProfileImage(String userId) =>
      "/users/updateProfileImage/$userId";

  static String addPhoneNumber(String userId) =>
      "/users/addPhoneNumber/$userId";

  static String deletePhoneNumber(String userId) =>
      "/users/deletePhoneNumber/$userId";

  static String deactivateAccount(String userId) =>
      "/users/deactivateUser/$userId";

  // Purchase Endpoints
  static const String purchases = "$baseUrl/purchases";

  static String purchaseById(String purchaseId) =>
      "$purchases/purchase/$purchaseId";

  static const String createPurchase = "$purchases/create";

  static String updatePurchase(String purchaseId) =>
      "$purchases/purchase/update/$purchaseId";

  static String cancelPurchase(String purchaseId) =>
      "$purchases/purchase/cancel/$purchaseId";

  static String receivePurchase(String purchaseId) =>
      "$purchases/purchase/receive/$purchaseId";
}
