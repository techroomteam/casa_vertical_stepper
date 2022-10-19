
The stepper widgets help you to show or collect information from users using organized steps.

## General Guidelines

* Simply import `package:casa_vertical_stepper/casa_vertical_stepper.dart`.

* __Expandable:__ The `isExpandable` argument controls whether the stepper is Expandable


## Usage

* __Expandable example:__

```Example
class ExampleScreen extends StatefulWidget {
  const ExampleScreen({Key? key}) : super(key: key);

  @override
  State<ExampleScreen> createState() => _ExampleScreenState();
}

class _ExampleScreenState extends State<ExampleScreen> {
  @override
  Widget build(BuildContext context) {
    final stepperList = [
      StepperStep(
        title: 'Account Details',
        leading: _checkBoxIcon(),
        view: YourCustomViewHere(),
      ),
      StepperStep(
        title: 'Application review',
        leading: _checkBoxIcon(isOutline: true, iconColor: primaryColor),
        view: YourCustomViewHere(),
      ),
    ];
    return Scaffold(
      body: Column(
          children: [
            CasaVerticalStepperView(
              steps: stepperList,
              seperatorColor: const Color(0xffD2D5DF),
              isExpandable: true,
              showStepStatusWidget: false,
            ),
          ],
      ),
    );
  }
}
```

* __StepStatus example:__

```Example
class ExampleScreen extends StatefulWidget {
  const ExampleScreen({Key? key}) : super(key: key);

  @override
  State<ExampleScreen> createState() => _ExampleScreenState();
}

class _ExampleScreenState extends State<ExampleScreen> {
  @override
  Widget build(BuildContext context) {
    final stepperList = [
      StepperStep(
        title: 'Account Details',
        leading: _checkBoxIcon(),
        view: YourCustomViewHere(),
      ),
      StepperStep(
        title: 'Application review',
        leading: _checkBoxIcon(isOutline: true, iconColor: primaryColor),
        status: StepStatus.fail,
        view: YourCustomViewHere(),
        failedView: YourCustomFailViewHere(),
    ];
    return Scaffold(
      body: Column(
          children: [
            CasaVerticalStepperView(steps: stepperList),
          ],
      ),
    );
  }
}
```

Screenshot
:-------------------------:
![](https://github.com/techroomteam/casa_vertical_stepper/raw/master/screenshot/1.png)

