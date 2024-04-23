import 'package:flutter/material.dart';
import 'package:prak_tpm_http/dao/users.dart';
import 'package:prak_tpm_http/model/user_detail.dart';

class UserDetailView extends StatefulWidget {
  final int id;

  const UserDetailView({super.key, required this.id});

  @override
  State<UserDetailView> createState() => _UserDetailViewState();
}

class _UserDetailViewState extends State<UserDetailView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: _buildLoadUser());
  }

  Widget _buildLoadUser() {
    return Expanded(
      child: FutureBuilder(
        future: UserDataSource.instance.loadUserDetail(widget.id),
        builder: (
          BuildContext context,
          AsyncSnapshot<dynamic> snapshot,
        ) {
          if (snapshot.hasError) {
            return _buildErrorSection();
          } else if (snapshot.hasData) {
            UserDetail userModel = UserDetail.fromJson(snapshot.data);
            return _buildSuccessSection(context, userModel.data!);
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

  Widget _buildSuccessSection(BuildContext context, User user) {
    return Scaffold(
      appBar: AppBar(title: Text("${user.firstName!} ${user.lastName!}")),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: _buildUser(context, user),
      ),
    );
  }

  Widget _buildUser(BuildContext context, User user) {
    double width = MediaQuery.of(context).size.width;

    return ListView(
      scrollDirection: Axis.vertical,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 6),
          height: width < 720 ? width : 256,
          // padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(14)),
            border: Border.all(color: Colors.black12),
            image: DecorationImage(
                image: NetworkImage(user.avatar!), fit: BoxFit.cover),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "${user.firstName!} ${user.lastName!}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                user.email!,
                style: const TextStyle(
                    fontSize: 16, color: Color.fromARGB(128, 0, 0, 0)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
