part of loan_syndicate;

class LoanSyndicate {
  
  Loan _lastLoan = new Loan();
  final Facility initialFacility;
  
  LoanSyndicate(this.initialFacility);
  
  Loan draw(num amount, {Facility facility}) {
    if (facility == null) facility = initialFacility;
    var amountsProration = facility.sharePie.prorate(amount);
    
    var loan = new Loan.clone(this._lastLoan);
    
    for (Company owner in amountsProration.owners) {
      var share = amountsProration.getShare(owner);
      loan.adjustShare(owner, share.value);
    }
    
    return _lastLoan = loan;
  }
  
  Loan payPrincipal(num principalAmount) {
    var loan = new Loan.clone(this._lastLoan);
    
    var principalsProration = loan.sharePie.prorate(principalAmount);
    for (Company owner in principalsProration.owners) {
      var share = principalsProration.getShare(owner);
      loan.adjustShare(owner, share.value * -1);
    }
    
    return _lastLoan = loan;
  }
  
  SharePie getChargeProration(num chargeAmount) => initialFacility.sharePie.prorate(chargeAmount);
  
  Loan get lastLoan => _lastLoan;
}
