# roseball
Draw a rose gift box using MATLAB.



```matlab
rose_box()
```
![](rose_box/_demo_r1.png)


```matlab
CList = {};
CList{1} = [.02 .04 .39; .02 .06 .69; .01 .26 .99; .17 .69 1];
CList{2} = [.02 .04 .39; .02 .06 .69; .01 .26 .99; .17 .69 1];
CList{3} = [14,51,134; 0,70,135; 0,90,156; 65,105,225; 197,213,236]./255;
rose_box(gca, CList)
```
![](rose_box/_demo_b1.png)
