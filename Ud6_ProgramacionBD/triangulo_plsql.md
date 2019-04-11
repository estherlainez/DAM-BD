```sql
DECLARE
	
	hipotenusa	 FLOAT; 
	base	 FLOAT; 
	altura FLOAT; 
	area	 FLOAT; 
	perimetro FLOAT; 
BEGIN
	
	hipotenusa :=&valor_hipotenusa_float; 

	base := &valor_base_float; 

	altura := &valor_altura_float; 

	area := .5 * base * altura; 

	perimetro := hipotenusa + altura + base; 

	dbms_output.Put_line(' El área del triángulo es: '
						|| area); 

	dbms_output.Put_line(' El perímetro del triángulo es: '
						|| perimetro); 
END; 
-- Program End 
```