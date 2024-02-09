function [rounds,tmSpent,castSpells]=aoc15_22_2(bHP,bDMG)

% player attributes
pHP=50;
pM=500;
pA=0;
% spells
missile=0;
drain=0;
shield=0;
poison=0;
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

    if poison==0 && pM>=173 && bHP>10
        poison=7;
    elseif poison==1 && pM>=173 && bHP>10
        poison=8;
    elseif recharge==0 && pM>=229 && bHP>26
        recharge=6;
    elseif shield==0 && pM>=113 && bHP>34
        shield=7;
    elseif shield==1 && pM>=113 && bHP>34
        shield=8;
    elseif drain==0 && pM>=73 && bHP>10
        drain=1;
    elseif pM>=53 && bHP>6
        missile=1;
    end

    % player turn
    pHP=pHP-1;
    if pHP<=0
        round(5)=pHP;
        round(6)=bHP;
        round(7)=pM;
        round(9)=mSpent;
        tmSpent=tmSpent+mSpent;
        rounds=[rounds;round];
        return
    end

    if missile>0
        mSpent=53;
        bHP=bHP-4;
        missile=0;
        castSpells{end+1,1}='missile';
    end

    if drain>0
        mSpent=73;
        bHP=bHP-2;
        pHP=pHP+2;
        drain=0;
        castSpells{end+1,1}='drain';
    end

    if shield==7
        mSpent=113;
        shield=shield-1;
        castSpells{end+1,1}='shield';
    elseif shield==8
        pA=7;
        mSpent=113;
        shield=6;
        castSpells{end+1,1}='shield';
    elseif shield>0
        pA=7;
        shield=shield-1;
    end

    if poison==7
        mSpent=173;
        poison=poison-1;
        castSpells{end+1,1}='poison1';
    elseif poison==8
        bHP=bHP-3;
        mSpent=173;
        poison=6;
        castSpells{end+1,1}='poison1';
    elseif poison>0
        bHP=bHP-3;
        poison=poison-1;
    end

    if recharge==6
        mSpent=229;
        recharge=recharge-1;
        castSpells{end+1,1}='recharge';
    elseif recharge>0
        pM=pM+101;
        recharge=recharge-1;
    end

    pM=pM-mSpent;

    % boss turn
    if shield>0
        pA=7;
        shield=shield-1;
    elseif shield==0
        pA=0;
    end

    if poison>0
        bHP=bHP-3;
        poison=poison-1;
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
end