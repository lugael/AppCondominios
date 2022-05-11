extension Iterables<E> on Iterable<E>{
  E? firstWhereOnNull(bool Function(E element) test){
    for(E element in this){
      if(test(element)){
        return element;
      }
    }
    return null;
  }
}

extension MyDateTime on DateTime{
  bool isAfterOrEquals(DateTime other){
    return !isBefore(other);
  }
  bool isBeforeOrEquals(DateTime other){
    return !isAfter(other);
  }
}