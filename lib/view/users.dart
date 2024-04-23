import 'package:flutter/material.dart';
import 'package:prak_tpm_http/dao/users.dart';
import 'package:prak_tpm_http/model/users.dart';
import 'package:prak_tpm_http/view/user_detail.dart';

class UsersView extends StatefulWidget {
  final int page;

  const UsersView({super.key, this.page = 1});

  @override
  State<UsersView> createState() => _UsersViewState();
}

class _UsersViewState extends State<UsersView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(children: [
            _heading(context),
            _buildDetailUser(),
            // const SizedBox(height: 20)
          ]),
        ),
      ),
    );
  }

  Future? _future;

  @override
  void initState() {
    super.initState();
    _future = UserDataSource.instance.loadUsers(widget.page);
  }

  String keyword = "";
  List<DataUser> filteredItems = [];
  List<DataUser> userList = [];

  void _search(String val) {
    setState(() {
      keyword = val;
      filteredItems = userList
          .where((item) =>
              (item.firstName!.toLowerCase()).contains(val.toLowerCase()) ||
              (item.lastName!.toLowerCase()).contains(val.toLowerCase()) ||
              (item.email!.toLowerCase()).contains(val.toLowerCase()))
          .toList();
    });
  }

  Widget _heading(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(top: 16, bottom: 14),
        alignment: Alignment.centerLeft,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "User List 👨🏻‍🦰👩🏻‍🦰",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            _searchBar(context)
          ],
        ));
  }

  Widget _searchBar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      child: TextFormField(
        enabled: true,
        onChanged: (value) => _search(value),
        decoration: InputDecoration(
          hintText: 'Search user',
          prefixIcon: const Icon(Icons.search, color: Colors.black87),
          filled: true,
          fillColor: const Color.fromARGB(0, 0, 0, 0),
          contentPadding: const EdgeInsets.all(12),
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 1.75, color: Colors.black26)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(width: 1.75, color: Colors.black26)),
        ),
      ),
    );
  }

  Widget _buildDetailUser() {
    return Expanded(
      child: FutureBuilder(
        future: _future,
        builder: (
          BuildContext context,
          AsyncSnapshot<dynamic> snapshot,
        ) {
          if (snapshot.hasError) {
            return _buildErrorSection();
          } else if (snapshot.hasData) {
            UserListModel userModel = UserListModel.fromJson(snapshot.data);
            userList = [...?userModel.data];
            return _buildSuccessSection(context, userModel);
          }
          return _buildLoadingSection();
        },
      ),
    );
  }

  Widget _buildErrorSection() {
    return const Text("Error");
  }

  Widget _buildLoadingSection() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildSuccessSection(BuildContext context, UserListModel data) {
    return Column(
      children: [
        (keyword != "" && filteredItems.isEmpty)
            ? Container(
                margin: const EdgeInsets.only(top: 12),
                child: Text.rich(
                  TextSpan(
                    style: const TextStyle(fontSize: 16),
                    children: [
                      const TextSpan(text: "Can't find "),
                      TextSpan(
                          text: keyword,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      const TextSpan(text: " on menu."),
                    ],
                  ),
                ))
            : Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                  ),
                  itemCount:
                      (keyword != "") ? filteredItems.length : userList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _buildItemUser(
                        context,
                        (keyword != "")
                            ? filteredItems[index]
                            : userList[index]);
                  },
                ),
              ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          color: Colors.white,
          child: Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: data.page! <= 1
                      ? null
                      : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  UsersView(page: data.page! - 1),
                            ),
                          );
                        },
                  style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor:
                          data.page! <= 1 ? Colors.black12 : Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6))),
                  child: const Text("Previous"),
                ),
              ),
              const SizedBox(width: 12),
              Text("Page ${data.page}"),
              const SizedBox(width: 12),
              Expanded(
                child: TextButton(
                  onPressed: data.page! >= data.totalPages!
                      ? null
                      : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  UsersView(page: data.page! + 1),
                            ),
                          );
                        },
                  style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: data.page! >= data.totalPages!
                          ? Colors.black12
                          : Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6))),
                  child: const Text("Next"),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildItemUser(BuildContext context, DataUser user) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserDetailView(id: user.id!),
          ),
        );
      },
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.black26),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                // padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(14),
                      topRight: Radius.circular(14)),
                  image: DecorationImage(
                      image: NetworkImage(user.avatar!), fit: BoxFit.cover),
                ),
              ),
            ),
            Container(
              width: 84,
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "${user.firstName!} ${user.lastName!}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    user.email!,
                    style: const TextStyle(
                        fontSize: 12, color: Color.fromARGB(128, 0, 0, 0)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
