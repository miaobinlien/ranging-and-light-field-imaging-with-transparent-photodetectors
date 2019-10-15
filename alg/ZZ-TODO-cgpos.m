 function [x,rho,eta,flps]=poscgls(G,k,t,tol)
% [x,rho,eta,flps]=poscgls(A,b,t,tol)
% minimize the system Ax=b with x>0 with  cg method
% Number of iterations is t
% x0 is an initial guess, if no guess is given x0=0
%	Eldad Haber
%	Geophysical Inversion Facility
%	University of British Columbia
% Algorithm - Hestenes, The Conjugate Direction Methods in 
% Optimization  p. 212 
% E.Haber  9.5.96

flops(0);
rho(1)=norm(k);eta(1)=0;
flps(1)=0;
[N,M]=size(G);

% Step 1
if nargin==3, tol=norm(k)*1e-4;  end
x=zeros(M,1);
g=k-G*x;
r=G'*g;

% Step 2
I=find(x==0 & r<0); notI=find(x~=0 | r>=0);
r_notI=r(notI);
zeros_r_notI=find(abs(r_notI)<1e-14);
if length(zeros_r_notI)==length(r_notI), return, end

% Step 3
r_bar=r; r_bar(I)=zeros(size(I));  p=r_bar;

% Step 4
for i=1:t,
      q=G*p; 
      if norm(q)==0, 
             disp('Iterationtrminated');number_iteration=i,return; 
      end
      c=q'*g; a=c/(q'*q);

%     Trancation stage for stability
      ii=find(x<0); x(ii)=zeros(size(ii));

      x=x+a*p;
      g=g-a*q;
      r=G'*g;
      not_in_S=find(x<0);
      r_notI=r(notI);
      zeros_r_notI=find(abs(r_notI)<1e-14);

      if length(not_in_S)>=1, %  step 5             
	     nz=find(p(not_in_S)~=0);
             x_not_in_S=x(not_in_S); p_not_in_S=p(not_in_S);
	     nz=find(p_not_in_S~=0);
             a=min(-x_not_in_S(nz)./p_not_in_S(nz));
             x=x+a*p;
             g=g-a*q;  % g=k-G*x
             r=G'*g;
             I=find(abs(x)<1e-14); notI=find(abs(x)>=1e-14);
             r_notI=r(notI);
             zeros_r_notI=find(abs(r_notI)<1e-14);

	     if length(zeros_r_notI)==length(r_notI), % repeat step 2                  
		   I=find(x==0 & r<0); notI=find(x~=0 | r>=0);
                   r_notI=r(notI);
                   zeros_r_notI=find(abs(r_notI)<1e-14);
                   if length(zeros_r_notI)==length(r_notI), return, end
	     end
		   % Step 3
                   r_bar=r; r_bar(I)=zeros(size(I));  p=r_bar;
              
      elseif length(zeros_r_notI)==length(r_notI), % go to step 2
	     g=k-G*x; % (not nesesary)
	     I=find(x==0 & r<0); notI=find(x~=0 | r>=0);
	     r_notI=r(notI);
	     zeros_r_notI=find(abs(r_notI)<1e-14);
	     if length(zeros_r_notI)==length(r_notI), return, end

	     % Step 3
	     r_bar=r; r_bar(I)=zeros(size(I));  p=r_bar;
         
      else
	     r_bar=r; r_bar(I)=zeros(size(I)); 

% For relativly low presision find b by the next line (save flops)
%	     b=(r_bar'*r_bar)/(q'*q);
%   
             b=-(q'*G*r_bar)/(q'*q); 
             p=r_bar+b*p;
      end
      rho(i+1)=norm(g); eta(i+1)=norm(x); flps(i+1)=flops;
      if rho(i+1)<tol, return, end
      fprintf('Finish iteration number %f\n', i);
end
