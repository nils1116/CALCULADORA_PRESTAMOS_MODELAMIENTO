function calculo_prestamo(monto, tasa_anual, plazo)

  % Datos para interpolación
  x = [
    1000000, 5, 1;
    2000000, 5, 1;
    1000000, 10, 1;
    2000000, 10, 1;
    1000000, 5, 2;
    2000000, 5, 2;
    1000000, 10, 2;
    2000000, 10, 2
  ];
  y = [
    85941.47; 171882.94; 87598.21; 175196.42;
    43856.24; 87712.48; 45992.18; 91984.36
  ];

  % Función Lagrange unidimensional
  function L = lagrange(x_vals, y_vals, x_target)
    n = length(x_vals);
    L = 0;
    for i = 1:n
      Li = 1;
      for j = 1:n
        if i ~= j
          Li = Li * ((x_target - x_vals(j)) / (x_vals(i) - x_vals(j)));
        end
      end
      L = L + Li * y_vals(i);
    end
  end

  % Interpolación por monto (filtrar con tasa=5 y plazo=1)
  idx_monto = (x(:,2) == 5) & (x(:,3) == 1);
  cuota_monto = lagrange(x(idx_monto,1), y(idx_monto), monto);

  % Interpolación por tasa (filtrar con monto=1000000 y plazo=1)
  idx_tasa = (x(:,1) == 1000000) & (x(:,3) == 1);
  cuota_tasa = lagrange(x(idx_tasa,2), y(idx_tasa), tasa_anual);

  % Interpolación por plazo (filtrar con monto=1000000 y tasa=5)
  idx_plazo = (x(:,1) == 1000000) & (x(:,2) == 5);
  cuota_plazo = lagrange(x(idx_plazo,3), y(idx_plazo), plazo);

  % Combinar resultados (promedio simple)
  cuota_aproximada = (cuota_monto + cuota_tasa + cuota_plazo) / 3;

  % Mostrar resultados
  printf("Monto del prestamo: %.2f\n", monto);
  printf("Tasa de interes anual: %.2f\n", tasa_anual);
  printf("Plazo: %d\n", plazo);
  printf("Cuota mensual estimada: %.2f\n", cuota_aproximada);
end
