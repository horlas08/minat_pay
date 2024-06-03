class OnboardingContents {
  final String title;
  final String image;
  final String desc;

  OnboardingContents({
    required this.title,
    required this.image,
    required this.desc,
  });
}

List<OnboardingContents> contents = [
  OnboardingContents(
    title: "Stay Connected",
    image: "assets/images/onboard/1001609500.png",
    desc:
        "Discover the convenience of buying data, airtime, Cable tv subscription, Convert airtime to cash and Electricity bills all in one place.",
  ),
  OnboardingContents(
    title: "Best Data Plans",
    image: "assets/images/onboard/1001609501.png",
    desc: "Choose from a Variety of Data Packages to Suit Your Internet Needs",
  ),
  OnboardingContents(
    title: "Earn Rewards",
    image: "assets/images/onboard/1001609502.png",
    desc:
        "With MinatPay, you can earn rewards for every successful referral you make. Simply share your referral code with friends and family.",
  ),
  OnboardingContents(
    title: "Cheapest Rates",
    image: "assets/images/onboard/1001609503.png",
    desc:
        "With our platform, you always get the best rates and prices on everything from airtime, data transactions and even your bill payments.",
  ),
];
