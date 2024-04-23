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

  Widget _heading(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(top: 16, bottom: 12),
        alignment: Alignment.centerLeft,
        color: Colors.white,
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "User List 👨🏻‍🦰👩🏻‍🦰",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ],
        ));
  }

  Widget _buildDetailUser() {
    return Expanded(
      child: FutureBuilder(
        future: UserDataSource.instance.loadUsers(widget.page),
        builder: (
          BuildContext context,
          AsyncSnapshot<dynamic> snapshot,
        ) {
          if (snapshot.hasError) {
            return _buildErrorSection();
          } else if (snapshot.hasData) {
            UserListModel userModel = UserListModel.fromJson(snapshot.data);
            return _buildSuccessSection(userModel);
          }
          return _buildLoadingSection();
        },
      ),
    );
  }

  Widget _buildErrorSection() {
    return const Text("Error");
  }

  Widget _buildEmptySection() {
    return const Text("Empty");
  }

  Widget _buildLoadingSection() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildSuccessSection(UserListModel data) {
    return Column(
      children: [
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
            ),
            itemBuilder: (BuildContext context, int index) {
              return _buildItemUser(data.data![index]);
            },
            itemCount: data.data?.length,
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 12),
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

  Widget _buildItemUser(DataUser user) {
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
