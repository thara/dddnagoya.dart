part of loan_syndicate;

class Loan{

  final AmountPie sharePie;

  Loan() : this._(new AmountPie());
  Loan._(this.sharePie);
  Loan.clone(Loan other) : this._(other.sharePie);
  
  void adjustShare(Company owner, num amount) {
    Share newShare;
    if (sharePie.hasShare(owner)) {
      newShare = sharePie.getShare(owner) + amount;
    } else {
      newShare = new Share(owner, amount);
    }
    sharePie.putShare(newShare);
  }
  
  num getAmountBy(Company owner) {
    Share share = sharePie.getShare(owner);
    return (share == null) ? 0 : share.value;
  }
  
  num getAmount() => sharePie.owners.fold(0, (sum, owner) => sum + sharePie.getShare(owner).value);
}

