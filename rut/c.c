
main(){int T,M=0,S=1;scanf("%d",&T);for(;T;T/=10)S=(S+T%10*(9-M++%6))%11;
printf("%c\n",S?S+47:75);}
