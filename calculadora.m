classdef calculadora
    
    properties
        mva = 0.622; %Masa vapor agua
        a = 16.54; %Antoine
        b = 3985; %Antoine
        c = -39.0; %Antoine
        cpa = 1005; %cp aire
        cpv = 1820; %cp agua
        pamb; %presion ambiente
        Tamb; %temperatura ambiente
        cagua = 4180; %c agua
        T0 = 273; %temperatura de referencia
        h0lv = 2501700; %entalpia de vaporizaion del agua
    end
    
    methods
        function obj = calculadora(p, T)
            %CALCULADORA Constructor
            obj.pamb = p;
            obj.Tamb = T;
        end
        
     function p_sat = psat(obj, varargin)
         %funcion sobrecargada, obtiene Psat a partir de la Temperatura.
         %si no se especifica, usa la ambiente (definida en el constructor)
            if nargin==1
                T = obj.Tamb;%psat()
            elseif nargin==2
                T = varargin{1};%psat(T)
            else
                error("Sobran argumentos de entrada")
            end
            p_sat = 1000*exp(obj.a - obj.b/(T + obj.c) );
        end

     function omega = omega(obj, varargin)
         %funcion sobrecargada, obtiene la humedad absoluta a partir de la
         %presion de saturacion, la HR y la presion. 
         %si la presion no se especifica, usa la ambiente (def en el
         %constructor)
            if nargin==3 %omega(ps, phi)
                p = obj.pamb;
            elseif nargin==4 %omega(ps, phi, p)
                p = varargin{3};
            else
                error("Faltan/sobran argumentos de entrada")
            end
            ps = varargin{1};
            phi = varargin{2};

            omega = (obj.mva)/( p/(phi*ps) - 1);
     end

     function tdew = tdew(obj, varargin)
         %funcion sobrecargada, que obtiene la temperatura de rocio a
         %partir de la HR y la temperatura. Si la temperatura no se
         %especifica, usa la ambiente (definda en el constructir)
            if nargin==2
                T = obj.Tamb;%tdew(phi)
            elseif nargin==3
                T = varargin{2};%psat(phi, T)
            else
                error("Faltan/sobran argumentos de entrada")
            end
            phi = varargin{1};

            tdew = -obj.c + 1/( 1/(T+obj.c) - log(phi)/obj.b );
     end

     function ma = ma(obj, T1a, T2a, T1w, T2w, omega1, omega2, mw1)
         %obtiene el gasto masico a partir de las temperaturas de entrada y
         %salida del agua y del aire, de las humedas absolutas y el gasto
         %masico del agua.
         h1 = obj.cpa * (T1a - obj.T0) + omega1 * (obj.h0lv + obj.cpv * (T1a - obj.T0));
         h2 = obj.cpa * (T2a - obj.T0) + omega2 * (obj.h0lv + obj.cpv * (T2a - obj.T0));
         h3 = obj.cagua*(T1w - obj.T0);
         h4 = obj.cagua*(T2w - obj.T0);
         ma = (mw1 * (h4 - h3))/(h1 + (omega2-omega1)*h4 - h2);
     end
    
     function mwevap = mwevap(~, omega1, omega2, ma)
         %obtiene la masa de agua evaporada (que coincidira con la
         %aportada) a partir de las humedades absolutas y el gasto masico.
         mwevap = ma*(omega2 - omega1);
     end
   end
end

