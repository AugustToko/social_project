import 'package:social_project/model/post.dart';

class PostViewModel {
  List<Post> postItems;

  PostViewModel({this.postItems});

  getPosts() => <Post>[
        Post(
            personName: "Geek Cloud",
            address: "China",
            likesCount: 100,
            commentsCount: 10,
            message: "如果你还不清楚发生了什么事情，请：《离职补偿变敲诈勒索 华为前员工被拘251天...",
            personImage:
                "https://avatars1.githubusercontent.com/u/20200460?s=460&v=4",
            messageImage:
                "https://cdn.pixabay.com/photo/2018/03/09/16/32/woman-3211957_1280.jpg",
            postTime: "Just Now"),
        Post(
            personName: "Geek Cloud",
            address: "China",
            likesCount: 123,
            commentsCount: 78,
            messageImage:
                "https://blog.geek-cloud.top/wp-content/uploads/2017/07/cooldp_161118_Natutal-Light_@%E5%96%9C%E6%AC%A2app-300x188.png",
            message:
                "Stellarium 是一款免费开源的GPL（自由软件基金会GNU通用公共许可证）软件，它使用OpenGL图形接口对星空进行实时渲染。软件可以真实地表现通过肉眼、双筒望远镜和小型天文望远镜所看到的天空，因此，我们可以通过它来观赏4星连珠的完整过程。",
            personImage:
                "https://avatars1.githubusercontent.com/u/20200460?s=460&v=4",
            postTime: "5h ago"),
        Post(
            personName: "Geek Cloud",
            address: "China",
            likesCount: 50,
            commentsCount: 5,
            message: " 蔚然一直崇尚“技术无国界”，但gitlab似乎并不这么认为，其公开对中国及俄罗斯...",
            personImage:
                "https://avatars1.githubusercontent.com/u/20200460?s=460&v=4",
            postTime: "2h ago"),
        Post(
            personName: "Geek Cloud",
            address: "China",
            likesCount: 23,
            commentsCount: 4,
            messageImage:
                "https://cdn.pixabay.com/photo/2014/09/07/16/53/hands-437968_960_720.jpg",
            message:
                "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s",
            personImage:
                "https://avatars1.githubusercontent.com/u/20200460?s=460&v=4",
            postTime: "3h ago"),
        Post(
            personName: "Geek Cloud",
            address: "China",
            likesCount: 35,
            commentsCount: 2,
            messageImage:
                "https://cdn.pixabay.com/photo/2015/11/26/00/14/fashion-1063100_960_720.jpg",
            message:
                "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s",
            personImage:
                "https://avatars1.githubusercontent.com/u/20200460?s=460&v=4",
            postTime: "1d ago"),
        Post(
            personName: "Geek Cloud",
            address: "China",
            likesCount: 100,
            commentsCount: 10,
            message:
                "Google Developer Expert for Flutter. Passionate #Flutter, #Android Developer. #Entrepreneur #YouTuber",
            personImage:
                "https://avatars1.githubusercontent.com/u/20200460?s=460&v=4",
            messageImage:
                "https://cdn.pixabay.com/photo/2018/03/09/16/32/woman-3211957_1280.jpg",
            postTime: "Just Now"),
        Post(
            personName: "Geek Cloud",
            address: "China",
            likesCount: 50,
            commentsCount: 5,
            message:
                "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s",
            personImage:
                "https://cdn.pixabay.com/photo/2013/07/18/20/24/brad-pitt-164880_960_720.jpg",
            postTime: "2h ago"),
        Post(
            personName: "Geek Cloud",
            address: "China",
            likesCount: 23,
            commentsCount: 4,
            messageImage:
                "https://cdn.pixabay.com/photo/2014/09/07/16/53/hands-437968_960_720.jpg",
            message:
                "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s",
            personImage:
                "https://avatars1.githubusercontent.com/u/20200460?s=460&v=4",
            postTime: "3h ago"),
        Post(
            personName: "Geek Cloud",
            address: "China",
            likesCount: 123,
            commentsCount: 78,
            messageImage:
                "https://blog.geek-cloud.top/wp-content/uploads/2017/07/cooldp_161028_%E6%9C%9B_@wangnaiming-768x480.jpg",
            message:
                "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s",
            personImage:
                "https://avatars1.githubusercontent.com/u/20200460?s=460&v=4",
            postTime: "5h ago"),
        Post(
            personName: "Geek Cloud",
            address: "China",
            likesCount: 35,
            commentsCount: 2,
            messageImage:
                "https://cdn.pixabay.com/photo/2015/11/26/00/14/fashion-1063100_960_720.jpg",
            message:
                "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s",
            personImage:
                "https://avatars1.githubusercontent.com/u/20200460?s=460&v=4",
            postTime: "1d ago"),
      ];
}
