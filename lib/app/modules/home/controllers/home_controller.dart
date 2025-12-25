import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/users_res_model.dart';
import '../repository/currency_repository.dart';

class HomeController extends GetxController {
  final UsersRepository _usersRepository = UsersRepository();

  // Observable states
  final RxList<UsersResModel> users = <UsersResModel>[].obs;
  final RxList<UsersResModel> filteredUsers = <UsersResModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString searchQuery = ''.obs;

  // Pagination
  final RxInt currentPage = 1.obs;
  final int itemsPerPage = 5;
  final RxBool hasMoreData = true.obs;

  // Search controller
  final TextEditingController searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
    _setupScrollListener();
  }

  @override
  void onClose() {
    searchController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  void _setupScrollListener() {
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        loadMoreUsers();
      }
    });
  }

  /// Fetch users from API
  Future<void> fetchUsers({bool isRefresh = false}) async {
    if (isRefresh) {
      currentPage.value = 1;
      hasMoreData.value = true;
    }

    if (isLoading.value) return;

    isLoading.value = true;
    hasError.value = false;
    errorMessage.value = '';

    try {
      final fetchedUsers = await _usersRepository.fetchUsers();
      users.assignAll(fetchedUsers);
      _applyFilters();
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  /// Pull to refresh
  Future<void> refreshUsers() async {
    await fetchUsers(isRefresh: true);
  }

  /// Load more users (pagination simulation)
  Future<void> loadMoreUsers() async {
    if (isLoadingMore.value || !hasMoreData.value || searchQuery.isNotEmpty) {
      return;
    }

    final totalPagesNeeded = (users.length / itemsPerPage).ceil();
    if (currentPage.value >= totalPagesNeeded) {
      hasMoreData.value = false;
      return;
    }

    isLoadingMore.value = true;

    // Simulate loading delay
    await Future.delayed(const Duration(milliseconds: 500));

    currentPage.value++;
    _applyFilters();

    isLoadingMore.value = false;
  }

  /// Search users by name
  void searchUsers(String query) {
    searchQuery.value = query.toLowerCase();
    currentPage.value = 1;
    hasMoreData.value = true;
    _applyFilters();
  }

  /// Clear search
  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
    currentPage.value = 1;
    hasMoreData.value = true;
    _applyFilters();
  }

  /// Apply search and pagination filters
  void _applyFilters() {
    List<UsersResModel> result = users.toList();

    // Apply search filter
    if (searchQuery.isNotEmpty) {
      result = result.where((user) {
        final name = user.name?.toLowerCase() ?? '';
        final email = user.email?.toLowerCase() ?? '';
        return name.contains(searchQuery.value) ||
            email.contains(searchQuery.value);
      }).toList();
      filteredUsers.assignAll(result);
    } else {
      // Apply pagination
      final endIndex = currentPage.value * itemsPerPage;
      final paginatedList = result.take(endIndex).toList();
      filteredUsers.assignAll(paginatedList);

      hasMoreData.value = paginatedList.length < result.length;
    }
  }
}
