classdef calculadora
    %CALCULADORA Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        mva = 0.622; %Masa vapor agua
        a = 16.54; %Antoine
        b = 3985; %Antoine
        c = -39.0; %Antoine
        pamb %presion ambiente
        Tamb %temperatura ambiente
    end
    
    methods
        function obj = calculadora(p, T)
            %CALCULADORA Constructor
            obj.pamb = p;
            obj.Tamb = T;
        end
        
     function p_sat = psat(obj, varargin)
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
    end
end

