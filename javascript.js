function transform(line) {
 var values = line.split(',');
 var obj = new Object();
 obj.name = values[0];
 obj.rollnumber = values[1];
 obj.branch = values[2];
 var jsonString = JSON.stringify(obj);
 return jsonString;
}
