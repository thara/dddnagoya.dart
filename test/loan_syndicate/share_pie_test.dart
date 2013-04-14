library share_pie_test;

import "package:dddnagoya/loan_syndicate.dart";

import 'package:unittest/unittest.dart';

main () => run();

run() {
  
  final Company owner_A = new Company(1);
  final Company owner_B = new Company(2);
  final Company owner_C = new Company(3);
  final Company owner_D = new Company(4);
  
  group("SharePie", () {
    test("#sum", () {
      SharePie sut = new SharePie();
      
      sut.putShare(new Share(owner_A, 10));
      sut.putShare(new Share(owner_B, 20));
      sut.putShare(new Share(owner_C, 30));
      
      expect(sut.sum(), equals(60));
    });
    
    test("#prorate", () {
      SharePie sut = new SharePie();
      
      sut.putShare(new Share(owner_A, 10));
      sut.putShare(new Share(owner_B, 20));
      sut.putShare(new Share(owner_C, 30));
      
      SharePie result = sut.prorate(120);
      
      expect(result.getShare(owner_A).value, equals(20));
      expect(result.getShare(owner_B).value, equals(40));
      expect(result.getShare(owner_C).value, equals(60));
      
      expect(sut.getShare(owner_A).value, equals(10));
      expect(sut.getShare(owner_B).value, equals(20));
      expect(sut.getShare(owner_C).value, equals(30));
    });
    
    test("#transfer", (){
      SharePie sut = new SharePie();
      
      sut.putShare(new Share(owner_A, 10));
      sut.putShare(new Share(owner_B, 20));
      sut.putShare(new Share(owner_C, 30));
      
      SharePie result = sut.transfer(owner_A, owner_B, 6);
      
      expect(result.getShare(owner_A).value, equals(4));
      expect(result.getShare(owner_B).value, equals(26));
      expect(result.getShare(owner_C).value, equals(30), reason: "must not be change owner_C's value");
      
      result = result.transfer(owner_A, owner_C, 2);
      
      expect(result.getShare(owner_A).value, equals(2));
      expect(result.getShare(owner_C).value, equals(32));
      expect(result.getShare(owner_B).value, equals(26), reason: "must not be change owner_B's value");
    });
  });
  
  group("AmountPie", () {
    test("#operator+", (){
      AmountPie sut = new AmountPie();
      sut.putShare(new Share(owner_A, 98.09));
      sut.putShare(new Share(owner_B, 31.91));
      sut.putShare(new Share(owner_C, 15.00));
      
      AmountPie param = new AmountPie();
      param.putShare(new Share(owner_A, 10.01));
      param.putShare(new Share(owner_B, 59.09));
      param.putShare(new Share(owner_C, 15.48));
      
      var result = sut + param;
      expect(result.getShare(owner_A).value.toStringAsFixed(1), equals("108.1"));
      expect(result.getShare(owner_B).value, equals(91.00));
      expect(result.getShare(owner_C).value, equals(30.48));
      
      param = new AmountPie();
      param.putShare(new Share(owner_A, 10.01));
      param.putShare(new Share(owner_C, 15.48));
      
      result = sut + param;
      expect(result.getShare(owner_A).value.toStringAsFixed(1), equals("108.1"));
      expect(result.getShare(owner_B).value, equals(31.91), reason:"this value must not be change.");
      expect(result.getShare(owner_C).value, equals(30.48));
    });
    
    test("#operator-", (){
      AmountPie sut = new AmountPie();
      sut.putShare(new Share(owner_A, 98.09));
      sut.putShare(new Share(owner_B, 31.91));
      sut.putShare(new Share(owner_C, 75.00));
      
      AmountPie param = new AmountPie();
      param.putShare(new Share(owner_A, 13.04));
      param.putShare(new Share(owner_B, 00.91));
      param.putShare(new Share(owner_C, 71.14));
      
      var result = sut - param;
      expect(result.getShare(owner_A).value.toStringAsFixed(2), equals("85.05"));
      expect(result.getShare(owner_B).value, equals(31.00));
      expect(result.getShare(owner_C).value.toStringAsFixed(2), equals("3.86"));
      
      param = new AmountPie();
      param.putShare(new Share(owner_B, 0.91));
      param.putShare(new Share(owner_C, 71.14));
      
      result = sut - param;
      expect(result.getShare(owner_A).value, equals(98.09), reason:"this value must not be change.");
      expect(result.getShare(owner_B).value, equals(31.00));
      expect(result.getShare(owner_C).value.toStringAsFixed(2), equals("3.86"));
    });
  });
}