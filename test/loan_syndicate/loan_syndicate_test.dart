library loan_syndicate_test;

import "package:dddnagoya/loan_syndicate.dart";

import 'package:unittest/unittest.dart';


main () => run();

run() {
  
  final Company owner_A = new Company(1);
  final Company owner_B = new Company(2);
  final Company owner_C = new Company(3);
  
  test("ファシリティの分担率に基づいて引き出しが配分される", () {
    
    Facility initialFacility = new Facility(30);
    initialFacility.join(owner_A, 2);
    initialFacility.join(owner_B, 7);
    initialFacility.join(owner_C, 1);
    
    LoanSyndicate sut = new LoanSyndicate(initialFacility);
    
    Loan loan = sut.draw(20);
    
    expect(loan.getAmount(), equals(20));
    expect(loan.getAmountBy(owner_A), equals(4));
    expect(loan.getAmountBy(owner_B), equals(14));
    expect(loan.getAmountBy(owner_C), equals(2));
  });
  
  test("買い出し側の1社が2回目の資金引き出しに加わらない場合", (){
    
    Facility initialFacility = new Facility(100);
    initialFacility.join(owner_A, 5);
    initialFacility.join(owner_B, 3);
    initialFacility.join(owner_C, 2);
    
    LoanSyndicate sut = new LoanSyndicate(initialFacility);
    
    Loan loan = sut.draw(50);
    expect(loan.getAmountBy(owner_A), equals(25));
    expect(loan.getAmountBy(owner_B), equals(15));
    expect(loan.getAmountBy(owner_C), equals(10));
    
    // B社が参加しないため、その分をA社が引き受ける
    Facility secondFacility = initialFacility.transfer(owner_B, owner_A, 3);
    expect(secondFacility.getPercentageOf(owner_A), equals(8));
    expect(secondFacility.getPercentageOf(owner_B), equals(0));
    expect(secondFacility.getPercentageOf(owner_C), equals(2));
    
    loan = sut.draw(10, facility: secondFacility);
    
    // 現在のローンの分配率はファシリティの分配率に比例していない
    expect(loan.getAmountBy(owner_A), equals(33));
    expect(loan.getAmountBy(owner_B), equals(15));
    expect(loan.getAmountBy(owner_C), equals(12));
    
    expect(loan.getAmount(), equals(60));
  });
  
  test("元本の支払いは常に未払いローンに対する分配率に比例して配分される", () {
    
    Facility initialFacility = new Facility(100);
    initialFacility.join(owner_A, 6);
    initialFacility.join(owner_C, 4);
    
    LoanSyndicate sut = new LoanSyndicate(initialFacility);
    
    Loan loan = sut.draw(20);
    expect(loan.getAmountBy(owner_A), equals(12));
    expect(loan.getAmountBy(owner_C), equals(8));
    
    Facility secondFacility = initialFacility.transfer(owner_C, owner_A, 2);
    expect(secondFacility.getPercentageOf(owner_A), equals(8));
    expect(secondFacility.getPercentageOf(owner_C), equals(2));
    
    // ローンの配分率: A : B = 18 : 7
    loan = sut.draw(30, facility:secondFacility);
    expect(loan.getAmountBy(owner_A), equals(36));
    expect(loan.getAmountBy(owner_C), equals(14));
    expect(loan.getAmount(), equals(50));
    
    loan = sut.payPrincipal(20);
    expect(loan.getAmount(), equals(30));
    
    // A社に対する元本支払い: 0.8 * 18 = 14.4
    // A社のローンの残り   : 36 - 14.4 = 21.6
    expect(loan.getAmountBy(owner_A), equals(21.6));
    // B社に対する元本支払い: 0.8 + 7 = 5.6
    // B社のローンの残り   : 14 - 5.6 = 8.4
    expect(loan.getAmountBy(owner_C), equals(8.4));
  });
}