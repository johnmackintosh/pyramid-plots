# pyramid-plots
Highland area population pyramids based on NRS Small Area Population Estimates (SAPE) 2020

All Highland areas:  

```r
facet_pyramid(pyramid_tots,
              council = Highland,
              facet_cols = 3)
```

![image](https://user-images.githubusercontent.com/3278367/173109678-a72bdf93-6470-40d9-8180-c8414f015376.png)  


Argyll and Bute:


```r
facet_pyramid(pyramid_tots,
              council = `Argyll and Bute`,
              facet_cols = 2)
```


![image](https://user-images.githubusercontent.com/3278367/173109557-20bfd0b8-44b5-4700-8063-1b9ec7e45e66.png)  

Specific areas within council:

```r
facet_pyramid(pyramid_tots,
              council = Highland,
              facet_cols = 3,
              ax_limits = "fixed",
              nbreaks = 8,
              Sutherland, Caithness, Lochaber)
```

![image](https://user-images.githubusercontent.com/3278367/173111083-10fc4658-0892-4c2c-99ad-33bbdf5ad2f5.png)  

All:

```r
facet_pyramid(pyramid_tots,
              council = NULL,
              facet_cols = 6,
              ax_limits = "fixed",
              nbreaks = 5)
 ```             
              
