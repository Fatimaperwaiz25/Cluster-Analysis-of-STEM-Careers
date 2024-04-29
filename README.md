# Cluster-Analysis-of-STEM-Careers
Categorizing participants' career choices using K-mean clustering of unsupervised career preference data.

# Introduction
Researchers use the term, STEM pipeline, to demonstrate “that the rates at which students currently enter STEM professions will be inadequate to keep up with the demands of our economy” (Cohen et al., 2013, p. 12). In order to build and sustain student interest in STEM disciplines, it is important first to ascertain the existing trends in their career choices and attitudes including factors influencing them. While most research focuses on students’ high school or post-secondary experiences, performance, and interests as predictors of their STEM career pathways (e.g., Dewitt et al., 2011; Maltese & Tai, 2011; Hinojosa et al., 2016), new investigations reveal that the journey toward choosing a career starts earlier than that (Wiebe et al., 2018). While lacking a detailed understanding of all the career pathways in STEM, students in early grades are capable of differentiating and showing interest in STEM careers in broader ways (Maltese & Tai, 2011). For example, in 2006, Tai et al. analyzed the data collected for the 1988 US National Educational Longitudinal Study and showed that students who showed interest in a science-related career by the age of 14 were 3.4 times more likely to pursue a degree in physical sciences and engineering than those without similar interests. The correlation was even stronger for students with high mathematical capabilities, with 51% earning a STEM degree. 

In order to address the gap in the literature regarding students’ career preferences in early years, this study aims to examine the relationship between students' attitudes toward different STEM disciplines (Science, Technology, Mathematics, and Engineering) and their career choices using the Student Attitudes Toward STEM Surveys [S-STEM] (Corn et al., 2012). 

# Research Question
What is the relationship between attitudes in STEM academic areas and STEM career interests in middle school?
Data
The data for the study was collected from 8 middle schools in Indiana. 270 students took the Student Attitudes Toward STEM (S-STEM) survey to record their responses. In the survey, there were three constructs to measure student attitudes toward the four primary STEM subjects: science (9 items), mathematics (8 items), and engineering/technology (9 items). For each discipline, a five-point Likert scale was utilized -- from strongly disagree to strongly agree to ask students for their responses. There was an additional construct that measured students’ attitudes toward 21st-century skills. Additionally, to address external factors that may affect student interest in STEM, there were questions about whether or not students know adults working in STEM fields.

The S-STEM Survey measures student interest in twelve STEM career pathways: physics, environmental work, biology and zoology, veterinary work, mathematics, medicine, computer science, medical science, chemistry, energy, and engineering. A cluster analysis was run on student responses to these careers, and they were put into two clusters.  
X Variable: 
The numeric variables are the attitude scores of students in 
1.	Math
2.	Science
3.	Engineering & Tech
4.	21st-century skills

The categorical variables are
1.	Do you plan to go to college?
2.	Do you know any adults who work as scientists?
3.	Do you know any adults who work as engineers?
4.	Do you know any adults who work as mathematicians?
5.	Do you know any adults who work as technologists?
Each categorical variable has three possible answers.
•	Yes = 1
•	No = 2
•	Maybe = 0
Y Variable:
The two clusters of STEM careers were the Y variables:
●	Cluster 1: Average scores in physics, math, computer science, chemistry, engineering, energy
●	Cluster 2: Average scores in biology & zoology, environment work, veterinary work, medicine, medical science. 
From the distribution of careers in the two clusters, it can be said that cluster 2 is predominated by biological science disciplines, whereas cluster 1 comprises mathematically rigorous disciplines.
 
# Data Analysis
The relationship between attitudes towards STEM disciplines and STEM career preferences was assessed using multiple linear regression in R with career cluster score being the dependent/Y variable and discipline attitude scoring the X variable.
Individual Scatter plot and Regression
The first step of the analysis was to plot a scatter plot with each of the 4 numeric independent variables against the 2 dependent variables to see if there were any obvious linear trends. It was then followed by running a regression with individual x and y variables. 
