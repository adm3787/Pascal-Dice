unit pasklsay;

interface
uses crt,dos;
const enter=#13; arriba=#72; abajo=#80; derecha=#77; izquierda=#75;
type
 ptr=^nodo;
 nodo= record
  numero:char;
  sig:ptr
 end;
var primero,ultimo:ptr; menu_jugar:boolean; dificultad:byte;

procedure resaltar(x,y:byte; caracter:char);
procedure menu_pascal_dice;
procedure jugar_pascal_dice;
procedure final;

implementation
procedure resaltar(x,y:byte; caracter:char);
Begin
 gotoxy(x,y); textcolor(15); write(caracter); delay(70);
 gotoxy(x,y); if caracter='V' then textcolor(7) else textcolor(8); write(caracter)
End;
procedure menu_pascal_dice;
const
instrucciones: array[1..4] of string[65] =
('Memoriza la secuencia de colores para reproducirla posteriormente',
 'Si te equivocas en la secuencia perdes una vida',
 'Tenes 3 vidas para jugar',
 'El cuadro de abajo muestra como activar los colores');
var y_ant,y_act,ind:byte;

procedure escribe_opcion(opcion,tono:byte);
procedure cuadro_de_referencia;
Begin
writeln('|7,Q|8,W|9,E|');
writeln('|---+---+---|');
writeln('|4,A|5,S|6,D|');
writeln('|---+---+---|');
  write('|1,Z|2,X|3,C|');
End;
Begin
 textcolor(tono+8);
 Case opcion of
  5: begin gotoxy(37,opcion); write('Jugar') end;
  8: begin
      gotoxy(32,opcion); write('Dificultad');
      gotoxy(wherex + 2,opcion); write(dificultad:2)
     end;
  11:begin
      gotoxy(35,opcion); write('Como jugar');
      window(8,12,72,12); clreol; window(1,1,80,25);
      gotoxy(40 - (length(instrucciones[ind]) div 2), opcion + 1);
      write(instrucciones[ind]);
      window(33,18,46,25);
      if (ind = 4)and(tono = 7) or (ind <> 4) then clrscr
                                              else cuadro_de_referencia;
      window(1,1,80,25)
     end;
  14:begin gotoxy(37,opcion); write('Salir') end
 end{Case}
End;{escribe_opcion}
procedure cambiar_resaltar(lado:char; op:byte);
procedure Case_lado(x1,x2,mas:byte);
Begin
 Case lado of
  izquierda: resaltar(x1,op + mas,'<');
  derecha: resaltar(x2,op + mas,'>')
 end
End;
procedure valor_numerico(flecha:char; min,max:byte; var referente:byte);
Begin
 Case flecha of
  derecha:if referente < max then inc(referente);
  izquierda:if min < referente then dec(referente)
 end
End;
Begin
 Case op of
  8:begin valor_numerico(lado,1,10,dificultad); case_lado(43,46,0) end;
  11:begin valor_numerico(lado,1,4,ind); case_lado(7,73,1) end
 end
End;
procedure control(accion:char; var opcion:byte);
Begin
 Case accion of
  enter:Case opcion of
         5:menu_jugar:=true;
         14:dificultad:=11
        end;
  arriba:if 5 < opcion then dec(opcion,3);
  abajo:if opcion < 14 then inc(opcion,3);
  izquierda,derecha: cambiar_resaltar(accion,opcion)
 end
End;
procedure escribe_titulo;
const titulo = 'P A S C A L   D I C E';
Begin gotoxy(29,1); textcolor( random(15) + 1); write(titulo) End;
Begin{Menu_Pascal_Dice}
 y_act:=5; escribe_opcion(y_act,3); y_ant:=8; textcolor(8); gotoxy(43,8);
 write('<  >'); gotoxy(7,12); write('<'); gotoxy(73,12); write('>');ind:=1;
 repeat
  escribe_opcion(y_ant,7); inc(y_ant,3)
 until y_ant > 14;
 repeat
  escribe_titulo; y_ant:=y_act; control(readkey,y_act);
  escribe_opcion(y_ant,7); escribe_opcion(y_act,3);
 until menu_jugar or (dificultad = 11);
 clrscr
End;{menu_pascal_dice}
procedure jugar_pascal_dice;
var turno:boolean; vidas,aciertos:byte; destruye_cola_de_char:word; hacer:char;
procedure dibuja_cuadro(x1,y1,long,tono:byte);
var lin,col:byte;
Begin
 textcolor(tono);
 for lin:=y1 to (y1 + long - 1) do
  begin
   col:=x1;
   repeat
    gotoxy(col,lin); write('||'); inc(col,2)
   until col > (x1 + 2*(long - 1))
  end
End;
function genera_car:char;
Begin genera_car:=chr( random(9) + 49) End;
procedure inicializa_secuencia(var pri,ult:ptr; dificul:byte);
var aux:ptr;
Begin
 new(pri); pri^.numero:=genera_car; pri^.sig:=nil; ult:=pri; dec(dificul);
 while dificul > 0 do
  begin
   new(aux); aux^.numero:=genera_car; aux^.sig:=nil;
   ult^.sig:=aux; ult:=aux; dec(dificul)
  end
End;
procedure iniciar;
Begin
 inicializa_secuencia(primero,ultimo,dificultad); aciertos:=0; vidas:=3;
 textcolor(15); gotoxy(31,23); write(aciertos:3);
 gotoxy(57,wherey); write(vidas); turno:=true
End;
function xx(num_car:char):byte;
Begin
 Case num_car of
  '7','Q','4','A','1','Z': xx:=22;
  '8','W','5','S','2','X': xx:=34;
  '9','E','6','D','3','C': xx:=46
 end
End;
function yy(num_car:char):byte;
Begin
 Case num_car of
  '7','Q','8','W','9','E': yy:=4;
  '4','A','5','S','6','D': yy:=10;
  '1','Z','2','X','3','C': yy:=16
 end
End;
function equivalente(dato:char):char;
Begin
 if dato in ['Z','X','C','A','S','D','Q','W','E'] then
  Case dato of
   'Z':equivalente:='1'; 'X':equivalente:='2'; 'C':equivalente:='3';
   'A':equivalente:='4'; 'S':equivalente:='5'; 'D':equivalente:='6';
   'Q':equivalente:='7'; 'W':equivalente:='8'; 'E':equivalente:='9'
  end
End;
function color(num_car:char):byte;
const colores: array[1..9]of byte = (7,12,10,11,0,13,14,3,15);
Begin color:= colores[ ord(num_car) - 48] End;
procedure muestra_secuencia(kbza:ptr);
var x,y:byte; num:char;
Begin
 repeat
  num:=kbza^.numero; x:=xx(num); y:=yy(num); dibuja_cuadro(x,y,6,color(num));
  delay(300); kbza:=kbza^.sig; dibuja_cuadro(x,y,6,8); delay(210)
 until kbza = nil
End;
procedure borra_arriba; Begin gotoxy(22,2); clreol; textcolor(15) End;
procedure repite_secuencia(kbza:ptr);
var num:char; x,y:byte; fallido:boolean;
Begin
 x:=22; y:=4;
 fallido:=false;
 repeat
  num:=upcase(readkey);
  Case num of
   '1'..'9','Z','X','C','A','S','D','Q','W','E':
     if (equivalente(num) = kbza^.numero) or (num = kbza^.numero) then
      begin
       dibuja_cuadro(x,y,6,8); inc(aciertos); gotoxy(31,23); textcolor(15);
       write(aciertos:3); x:=xx(num); y:=yy(num);
       if num in ['1'..'9'] then dibuja_cuadro(x,y,6,color(num))
       else dibuja_cuadro(x,y,6,color(equivalente(num)));
       kbza:=kbza^.sig
      end
      else fallido:=true;
   izquierda:begin resaltar(1,25,'<'); menu_jugar:=false; exit end;
   'v','V':begin resaltar(35,25,'V'); iniciar; exit end
  end{case}
 until (kbza = nil) or fallido;
 if kbza = nil then begin turno:=false; delay(500) end;
 dibuja_cuadro(x,y,6,8);
 if turno then
           begin
            borra_arriba; gotoxy(36,2); write('FALLASTE'); delay(1500);
            dec(vidas); gotoxy(57,23); write(vidas)
           end
          else
           begin
            borra_arriba; gotoxy(34,2); write('BIEN HECHO!!'); delay(1500)
           end
End;
procedure agranda_secuencia(var ult:ptr; dificul:byte);
var aux:ptr;
Begin
 repeat
  new(aux); aux^.numero:=genera_car; aux^.sig:=nil;
  ult^.sig:=aux; ult:=aux; dec(dificul)
 until dificul = 0
End;
Begin{jugar_pascal_dice}
 textcolor(15); gotoxy(1,25); write('<-Menu'); 
 gotoxy(2,25);  gotoxy(34,25); write('[V]Reiniciar'); gotoxy(22,23);
 write('Aciertos:'); gotoxy(50,wherey); write('Vidas:');
 dibuja_cuadro(22,4,18,8); iniciar;
 repeat
  if turno then
            begin
             borra_arriba; gotoxy(29,2); write('MEMORIZA LA SECUENCIA');
             delay(1000); muestra_secuencia(primero); borra_arriba;
             for destruye_cola_de_char:=1 to 1000 do
              if keypressed then hacer:=readkey;
             gotoxy(36,2); write('TU TURNO');repite_secuencia(primero)
            end
           else
            begin agranda_secuencia(ultimo,dificultad); turno:=true end;
  if vidas = 0 then
                begin
                 borra_arriba; gotoxy(36,2); write('PERDISTE');
                 repeat
                  hacer:=readkey;
                  Case hacer of
                  izquierda:begin resaltar(1,25,'<'); menu_jugar:=false end;
                  'v','V':begin resaltar(35,25,'V'); iniciar; end
                  end
                 until (hacer = izquierda) or (upcase(hacer) = 'V')
                end
 until not menu_jugar;
 clrscr
End;{jugar_pascal_dice}
procedure final;
procedure texto_centrado(texto:string; lin,color:byte);
Begin gotoxy(39 - (length(texto) div 2),lin); textcolor(color); write(texto) End;
Begin
 clrscr;
 texto_centrado('Realizado por:',3,15);
 texto_centrado('Agustin Dario Medina',7,15);
 texto_centrado('Terminado el 26/03/2012',12,15);
 texto_centrado('Ultima modificacion: 08/08/2014',13,15);
 texto_centrado('Agradecimientos',18,15);
 texto_centrado(' A mi primo "El Gabi" por prestarme su notebook',20,15);
 texto_centrado(' Presionar cualquier tecla para salir',25,7);
 repeat until keypressed; textcolor(7); clrscr
End;
BEGIN dificultad:=1; clrscr; randomize; menu_jugar:=false END.
