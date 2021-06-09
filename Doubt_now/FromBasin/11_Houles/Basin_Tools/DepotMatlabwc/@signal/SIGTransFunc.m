function val = SIGTransFunc(varargin)

%calculates the transfert function with
%signal s1 as input
%signal s2 as output
%using the TFestimate MAtlab function
%
%Syntax : 
%val = SIGTransFunc(s1,s2)
%val = SIGTransFunc(s1,s2,offsetarg,Pwelchparam)
%val = SIGTransFunc(s1,s2,offsetarg=1 or 0,Pwelchparam,printarg=1 or 0)
%
%it returns in val 
%val =  [FTRfreq, abs(FTR), angle(FTR), COHfreq, abs(COH)];
%avec FTR et COH comme output de tfestimate et mscohere
%[FTR,FTRfreq] = tfestimate(Y1,Y2,paramPwelch{1},paramPwelch{2},paramPwelch{3},fech);       
%[COH,COHfreq] = mscohere(Y1,Y2,paramPwelch{1},paramPwelch{2},paramPwelch{3},fech);...

switch nargin
%     case 2
%         if(isa(varargin{1},'signal') && isa(varargin{2},'signal'))
%             s1 = varargin{1};
%             s2 = varargin{2};
%         else
%             error('Wrong type of input arguments')
%         end      
     
        
    case 2 
    if (isa(varargin{1},'signal') && isa(varargin{2},'signal'))
       s1 = varargin{1};
       s2 = varargin{2};
        offsetNull=0;
        paramPwelch={[],[],[]};
        printarg=0;
    else
        error('Wrong type of input arguments')
    end      
    case 3  
    if (isa(varargin{1},'signal') && isa(varargin{2},'signal') && isa(varargin{3},'double'))
        s1 = varargin{1};
       s2 = varargin{2};
        offsetNull =  varargin{3};
        paramPwelch={[],[],[]};
        printarg=0;
    else
        error('Wrong type of input arguments')        
    end
    case 4  
    if (isa(varargin{1},'signal') && isa(varargin{2},'signal') && isa(varargin{3},'double')  && isa(varargin{4},'cell'))
       s1 = varargin{1};
       s2 = varargin{2};
        offsetNull =  varargin{3};
        paramPwelch=varargin{4};
        printarg=0;
    else
        error('Wrong type of input arguments')        
    end

    case 5  
    if (isa(varargin{1},'signal') && isa(varargin{2},'signal') && isa(varargin{3},'double')  && isa(varargin{4},'cell') && isa(varargin{5},'double'))
       s1 = varargin{1};
       s2 = varargin{2};
        offsetNull =  varargin{3};
        paramPwelch=varargin{4};
        printarg=varargin{5};
    else
        error('Wrong type of input arguments')        
    end
    otherwise
   error('Wrong number of input arguments')
end
        
        
        
        
    % ss = [s1, s2];
    % plotn(ss);
    
     Y1 = get(s1,'Y');
     Y2 = get(s2,'Y');

      if offsetNull == 1
     %Offset is set to 0
     Y1 = Y1 - mean(Y1);
     Y2 = Y2 - mean(Y2);
     end
     N = length(Y1);
     fech=1/s1.dt;
     
     
     %[FTR,FTRfreq] = tfestimate(Y1,Y2,[],[],N,100);    
     %[COH,COHfreq] = mscohere(Y1,Y2,[],[],N,100);
     [FTR,FTRfreq] = tfestimate(Y1,Y2,paramPwelch{1},paramPwelch{2},paramPwelch{3},fech);       
     [COH,COHfreq] = mscohere(Y1,Y2,paramPwelch{1},paramPwelch{2},paramPwelch{3},fech);
         
        
     TF1 = SIGTransFour(s1,1);
     TF2 = SIGTransFour(s2,1);
     FTR2 = TF2(:,2)./TF1(:,2);
     ind  = find(TF1(:,1)>0.2);
     ind2  = find(FTRfreq(:,1)>0.2);
     
     if printarg==1
     figure;
     subplot(311); hcolorbar=bar(TF1(ind,1),FTR2(ind));
     set(hcolorbar,'FaceColor','Cyan','Edgecolor','Cyan');%,'EdgeColor','r'
     title(['RAO - Channel : ' get(s2,'nom')])
    % [FTRsmooth , p] =csaps(TF1(:,1),FTR2,1-5e-5,TF1(:,1));
    % hold on;
    % plot(TF1(ind),FTRsmooth(ind)/10,'--');
     hold on; grid on; 
     ylabel(['Amplitude ' get(s2,'unite') '/' get(s1,'unite')]);
     plot(FTRfreq,abs(FTR));
     
      ylim([0 1.5*max(abs(FTR(ind2)))]);
     %ylim([0 22]);
     % xlim([FTRfreq(ind2(1)) 2]);
     legend('Unaveraged','Welch average')
     
     subplot(312);plot(COHfreq,angle(FTR)/2/pi*360,'r');
     hold on; grid on;
    % xlim([FTRfreq(ind2(1)) 2]);
     ylim([-180 180])
     ylabel('Phase (°)' )
     legend('Welch average');
     
     subplot(313);plot(COHfreq,abs(COH),'r');
     hold on; grid on; 
    % xlim([FTRfreq(ind2(1)) 2]);
     ylabel('Coherence [1]');
         legend('Welch average');
     
     
     end
     
        
     
     val =  [FTRfreq, abs(FTR), angle(FTR), COHfreq, abs(COH)];   
        
       
end