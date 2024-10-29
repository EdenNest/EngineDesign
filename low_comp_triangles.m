close all
% figure(1)
% vtplot(C_mean(1,1)-1,u_mean, V_mean(1,1))
% vtplot(C_mean(2,1),u_mean, V_mean(2,1))

for j=1:4
        figure('name','Mean')
        str = sprintf('Mean Stage %d',j)
        vtplot(C_mean(1,j)-0.001,u_mean, V_mean(1,j))
        vtplot(C_mean(2,j),u_mean, V_mean(2,j))
        title(str);
end

% 
% for j=1:4
%         figure('name','Tip')
%         str = sprintf('stage= %d',j)
%         vtplot(C_tip(1,j)-0.001,U_tip(1,j), V_tip(1,j))
%         vtplot(C_tip(2,j),U_tip(2,j), V_tip(2,j))
%         title(str);
% end
%%
for j=1:4
        
        str = sprintf('Tip stage %d',j);
        figure('name',str)
        subplot(1,2,1)
        vtplot(C_tip(1,j)-0.001,U_tip(1,j), V_tip(1,j))
        title('rotor');
        subplot(1,2,2)
        vtplot(C_tip(2,j),U_tip(2,j), V_tip(2,j))
        title('stator');
end

for j=1:4
        
        str = sprintf('Hub stage %d',j);
        figure('name',str)
        subplot(1,2,1)
        vtplot(C_hub(1,j)-0.001,U_hub(1,j), V_hub(1,j))
        title('rotor');
        subplot(1,2,2)
        vtplot(C_hub(2,j),U_hub(2,j), V_hub(2,j))
        title('stator');
end
