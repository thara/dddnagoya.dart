part of loan_syndicate;

class Facility {
  
  final num limit;
  final PercentagePie sharePie;
  
  Facility(num limit) : this._(limit, new PercentagePie());
  
  Facility._(this.limit, this.sharePie);
  
  void join(Company owner, num percentage) {
    var share = new Share(owner, percentage);
    sharePie.putShare(share);
  }
  
  Facility transfer(Company from, Company to, num percentage) {
    var result = sharePie.transfer(from, to, percentage);
    var newPie = new PercentagePie.clone(result);
    return new Facility._(limit, newPie);
  }
  
  num getPercentageOf(Company owner) {
    var share = sharePie.getShare(owner);
    return share == null ? 0 : share.value;
  }
}