part of loan_syndicate;

class Company {
  final int id;
  Company(this.id);
  
  int get hashCode => this.id;
  
  bool operator== (other) {
    if (identical(this, other)) return true;
    if (other is Company == false) return false;
    return this.id == (other as Company).id;
  }
  
  String toString() => "Company[${id}]";
}