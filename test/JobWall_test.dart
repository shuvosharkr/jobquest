import 'package:jobquest/JobPost.dart';
import 'package:test/test.dart';
void main() {
  group('JobWall tests', () {
    test('JobPost exists', () {
      // ignore: prefer_const_constructors
      final job = JobPost( jobname: 'A', user: 'hafsamahbub@gmail.com', course: 'B', description: 'C', deadline: 'D', pay: 'E',);
      expect(job.jobname, 'A');
      expect(job.user, 'hafsamahbub@gmail.com');
      expect(job.course, 'B');
      expect(job.description, 'C');
      expect(job.deadline, 'D');
      expect(job.pay, 'E');

    });
    test('JobPost does not exist', () {
      // ignore: prefer_const_constructors
      final job = JobPost( jobname: 'A', user: 'hafsamahbub@gmail.com', course: 'B', description: 'C', deadline: 'D', pay: 'E',);
      expect(job.jobname, 'X');
      expect(job.user, 'hafsamahbub@gmail.com');
      expect(job.course, 'B');
      expect(job.description, 'C');
      expect(job.deadline, 'D');
      expect(job.pay, 'E');

    });
  });
}