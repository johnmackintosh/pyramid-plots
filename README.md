# pyramid-plots
Highland area population pyramids based on NRS Small Area Population Estimates (SAPE) 2020 / 2021


Latest data sources:

[persons](https://www.nrscotland.gov.uk/files//statistics/population-estimates/sape-time-series/persons/sape-2021-persons.xlsx)
[males](https://www.nrscotland.gov.uk/files//statistics/population-estimates/sape-time-series/males/sape-2021-males.xlsx)
[females](https://www.nrscotland.gov.uk/files//statistics/population-estimates/sape-time-series/females/sape-2021-females.xlsx)


All Highland areas:  

```r
facet_pyramid(pyramid_tots,
              council = Highland,
              facet_cols = 3)
```
2021: 

![image](https://user-images.githubusercontent.com/3278367/190691452-f6950b00-b6dc-45f4-8c95-04a6bb48d646.png)

2020: 

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
2021: 
![image](https://user-images.githubusercontent.com/3278367/190691699-2c4c9e63-63b9-442a-bd69-530bbaf2b54b.png)



2020: 
![image](https://user-images.githubusercontent.com/3278367/173111083-10fc4658-0892-4c2c-99ad-33bbdf5ad2f5.png)  

All:

```r
facet_pyramid(pyramid_tots,
              facet_cols = 6,
              nbreaks = 3)
 ```             
 
 ![image](https://user-images.githubusercontent.com/3278367/173323629-04f570ad-dabc-4ddc-b2fb-2e6beb58b27b.png)

## Animation of Inverness area projections

![image](https://github.com/johnmackintosh/pyramid-plots/blob/73c2ac559f1e648f12f02215609665dbef383df2/projections-animation.gif)


![image](https://github.com/johnmackintosh/pyramid-plots/blob/ccf3f79dadd997a7d5a0285492554580efc06b88/source_data/inverness_population_projections.png)


![image](https://user-images.githubusercontent.com/3278367/214272593-40d2a04a-cebb-43ee-8f0d-9c7a351ea17c.png)


