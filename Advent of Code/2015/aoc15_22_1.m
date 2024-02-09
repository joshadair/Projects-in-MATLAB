function [rounds,tmSpent,castSpells]=aoc15_22_1(bHP,bDMG)

% player attributes
pHP=50;
pM=500;
pA=0;
% spells
missile=0;
drain=0;
shield=0;
poison1=0;
poison2=0;
recharge=0;

% total mana spent
tmSpent=0;

rounds=[];
castSpells={};
while bHP>0
    mSpent=0;
    round=zeros(1,9);
    round(1)=pM;
    round(2)=pHP;
    round(3)=bHP;

    % spell strategy
    if poison1==0 && pM>=173 && bHP>14
        poison1=7;
    elseif poison1==1 && pM>=173 && bHP>14
        poison1=8;
    elseif recharge==0 && bHP>34 && pM>=229
        recharge=6;
    elseif shield==0 && pM>=113 && bHP>31
        shield=7;
    %elseif poison2==0 && pM>=173
       % poison2=7;
    elseif drain==0 && pM>=73 && bHP>34
        drain=1;
    elseif pM>=53
        missile=1;
    end

    %{
    if poison<=1 && bHP>15
        poison=7;
    elseif recharge==0 && bHP>46
        recharge=6;
    elseif shield==0
        if bHP>19
            shield=7;
        else
            drain=1;
        end
    elseif drain==0 && pM>=73 && turn~=9
        drain=1;
    elseif bHP>2 && pM>=53
        missile=1;

    end

    %}




    %{

    if turn==1
        poison=7;
    elseif turn==3
        recharge=6;
    %{
    elseif turn==5
        shield=7;
    elseif turn==7
        drain=1;
    %}
    elseif turn==15
      poison=7;
    elseif shield<=1 && bHP/7>pHP/8
        if recharge==0 && pM<282
            recharge=6;
        else
            shield=7;
        end
    elseif poison==0 && turn<17
        poison=7;
    elseif shield<=1 && bHP/7<=pHP/8 && turn<15
        missile=1;
    elseif pM-229<53 && bHP>23 && recharge==0
        recharge=6;
    elseif pHP<=2
        drain=1;
    elseif turn<15
        missile=1;
    end
    %}

    % player turn
    if missile>0
        mSpent=53;
        bHP=bHP-4;
        missile=0;
        castSpells{end+1}='missile';
    end

    if drain>0
        mSpent=73;
        bHP=bHP-2;
        pHP=pHP+2;
        drain=0;
        castSpells{end+1}='drain';
    end

    if shield==7
        mSpent=113;
        shield=shield-1;
        castSpells{end+1}='shield';
    elseif shield>0
        pA=7;
        shield=shield-1;
    end

    if poison1==7
        mSpent=173;
        poison1=poison1-1;
        castSpells{end+1}='poison1';
    elseif poison1==8
        bHP=bHP-3;
        mSpent=173;
        poison1=6;
        castSpells{end+1}='poison1';
    elseif poison1>0
        bHP=bHP-3;
        poison1=poison1-1;
    end

    if recharge==6
        mSpent=229;
        recharge=recharge-1;
        castSpells{end+1}='recharge';
    elseif recharge>0
        pM=pM+101;
        recharge=recharge-1;
    end
    pM=pM-mSpent;
    %round(4)=mSpent;



    % boss turn
    if shield>0
        pA=7;
        shield=shield-1;
    elseif shield==0
        pA=0;
    end

    if poison1>0
        bHP=bHP-3;
        poison1=poison1-1;
    end

    if recharge>0
        pM=pM+101;
        recharge=recharge-1;
    end

    if bHP>0
        pHP=pHP-(bDMG-pA); %boss attack
    end
 

    % boss and player health at end of round
    round(5)=pHP;
    round(6)=bHP;
    round(7)=pM;
    round(9)=mSpent;
    tmSpent=tmSpent+mSpent;
    rounds=[rounds;round]; % round summary
end

castSpells=castSpells';
end




%{
startSpells={'recharge',5;'shield',6;'drain',1;'missile',1;'poison',0};

while bHP>0
    if turn==1
        activeSpells=startSpells;
    end
    activeSpellNames={activeSpells{:,1}};
    activeSpellDurations={activeSpells{:,2}};


    if any(contains(activeSpellNames,'recharge'))
        pM=pM+101;
        activeSpellDurations{contains(activeSpellNames,'recharge')}=activeSpellDurations{contains(activeSpellNames,'recharge')}-1;
    end

    if pHP<bDMG
        activeSpells{end+1}={'drain',};
    end





    if any(contains(activeSpellNames,'shield'))
        pHP=pHP-(bDMG-7);
else
    pHP=pHP-bDMG;
    end


end


end
%}