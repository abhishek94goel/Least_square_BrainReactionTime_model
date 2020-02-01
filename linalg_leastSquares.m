% loading the EEG data file
load EEG_RT_data.mat
N = length(rts);

% plotting the data
figure(1), clf
subplot(211)
plot(rts,'ks-','markersize',14,'markerfacecolor','k')
xlabel('Trial No.'), ylabel('Response time (in ms)')

subplot(212)
imagesc(1:N,frex,EEGdata)
axis xy
xlabel('Trial No.'), ylabel('Frequency')
set(gca,'clim',[0 10])

%% Section for the creation of least square model and fitting of the EEG data.

% design of matrix
X = [ ones(N-1,1) rts(1:end-1)' EEGdata(9,2:end)' ];

% computing the parameters (evaluation of the coefficient using least square linear algebra equation)
b = (X'*X)\(X'*rts(2:end)')

% interpreting the obtained coefficients
disp([ 'Intercept: ' num2str(b(1)) ' ms' ])
disp([ 'Effect of prev. RT: ' num2str(b(2)*std(rts)) ' ms' ])
disp([ 'Effect of EEG energy: ' num2str(b(3)*std(rts)/std(EEGdata(9,:))) ' ms' ])

%% computing the effect of coefficients over frequencies

b = zeros(size(frex));

for fi=1:length(frex)
    
    % designing the matrix
    X = [ ones(N,1) EEGdata(fi,:)' ];
    
    % parameters computation
    t = (X'*X)\(X'*rts');
    b(fi) = t(2);
end

% plot
figure(2), clf
subplot(211)
plot(frex,b,'rs-','markersize',14,'markerfacecolor','k')
xlabel('Frequency (in Hz)')
ylabel('\beta-coefficient')


% scatterplots at these frequencies
frex2plot = dsearchn(frex',[ 8 20 ]');

for fi=1:2
    subplot(2,2,2+fi)
    
    plot(EEGdata(frex2plot(fi),:),rts,'rs','markerfacecolor','k')
    h=lsline;
    set(h,'linew',2,'color','k')
    
    xlabel('EEG energy'), ylabel('RT')
    title([ 'EEG signal at ' num2str(round(frex(frex2plot(fi)))) ' Hz' ])
end

%% Abhishek Goel - abhishek94goel@gmail.com
