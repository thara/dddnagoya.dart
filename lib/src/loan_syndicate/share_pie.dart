part of loan_syndicate;

class Share {
  final Company owner;
  final num value;
  
  Share(this.owner, this.value);
  
  Share operator+(num amount) => new Share(this.owner, this.value + amount);
  Share operator-(num amount) => new Share(this.owner, this.value - amount);
  
  String toString() => "Share[${owner}:${value}]";
}

class SharePie {
  
  final Map<Company, Share> shares;
  
  SharePie() : this._(new Map());
  SharePie._(this.shares);
  SharePie.clone(SharePie original) : this._(new Map.from(original.shares));
  
  Set<Company> get owners => new Set.from(this.shares.keys);
  
  putShare(Share share) => shares[share.owner] = share;
  
  Share getShare(Company owner) => shares[owner];
  
  bool hasShare(Company owner) => shares.containsKey(owner);
  
  SharePie prorate(num value) {
    num sum = this.sum();
    return shares.values.fold(new SharePie(), (newPie, share) {
      num prorated = value * share.value / sum;
      newPie.putShare(new Share(share.owner, prorated));
      return newPie;
    });
  }
  
  SharePie transfer(Company from, Company to, num value) {
    
    var fromShare = shares[from];
    var toShare = shares[to];
    
    if (fromShare == null || toShare == null) throw new ArgumentError();
    
    var newFromShare = fromShare - value;
    if (newFromShare.value < 0) throw new ArgumentError();
    
    var newSharePie = new SharePie.clone(this);
    newSharePie.putShare(newFromShare);
    newSharePie.putShare(toShare + value);
    return newSharePie;
  }
  
  num sum() => shares.values.fold(0, (sum, share) => sum + share.value);
}

class PercentagePie extends SharePie {
  
  PercentagePie() : super._(new Map());
  PercentagePie.clone(SharePie original) : super.clone(original);
  
  void putShare(Share share) {
    if (sum() + share.value > 100) throw new ArgumentError();
    super.putShare(share);
  } 
}

class AmountPie extends SharePie {
  
  AmountPie() : super._(new Map());
  AmountPie.clone(SharePie original) : super.clone(original);
  
  AmountPie operator+ (AmountPie other) =>
    _bind(other, (myAmount, otherAmount) => myAmount + otherAmount);
  
  AmountPie operator- (AmountPie other) =>
    _bind(other, (myAmount, otherAmount) => myAmount - otherAmount);
  
  AmountPie _bind(other, num newAmount(num myAcount, num otherAcount)) {
    var newPie = new AmountPie();
    
    var ownersAll = this.owners.union(other.owners);
    ownersAll.forEach((owner) {
      var myShare = getShare(owner);
      var otherShare = other.getShare(owner);
      var myAmount = (myShare == null) ? 0 : myShare.value;
      var otherAmount = (otherShare == null) ? 0 : otherShare.value;
      newPie.putShare(new Share(owner, newAmount(myAmount, otherAmount)));
    });
    
    return newPie;
  }
}