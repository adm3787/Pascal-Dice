program juego3;
uses pasklsay;
begin
 repeat
 if menu_jugar then jugar_pascal_dice
               else menu_pascal_dice
 until dificultad =11;
 final;
end.
