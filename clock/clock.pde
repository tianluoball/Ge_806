int majorLevel = 1; 
int minorLevel = 1;  
int score = 0;
String userInput = "";
boolean isTyping = false;

HashMap<Integer, ArrayList<String>> tzDatabase = new HashMap<Integer, ArrayList<String>>();
ArrayList<String> usedCities = new ArrayList<String>();
int currentTZ;
int hour;
String timezone;

float rotation = 0;
float[] numberSizes = new float[12];

void setup() 
{
  size(800, 600);
  textAlign(CENTER, CENTER);
  setupTimezoneDatabase();
  randomizeTimeAndZone();
  
  for (int i = 0; i < 12; i++) 
  {
    numberSizes[i] = 24;
  }
}

void draw() 
{
  background(40);
  
  pushMatrix();
  translate(width/2, height/2 - 100);
  
  drawClock();
  popMatrix();
  
  fill(255);
  textSize(20);
  text("Level: " + majorLevel + "-" + minorLevel, 60, 30);
  text("Score: " + score, width-60, 30);
  
  // input text
  fill(60);
  rect(200, height-100, width-400, 40);
  fill(255);
  text(userInput + (frameCount % 60 < 30 ? "|" : ""), width/2, height-80);
  
  textSize(16);
  text("Enter a city in the same timezone", width/2, height-130);
  text("Used cities: " + String.join(", ", usedCities), width/2, height-40);
}

String getTimezoneDisplay(int tz) 
{
  if (tz == 55) return "UTC+5:30";
  if (tz < 0) return "UTC" + tz;
  return "UTC+" + tz;
}

// check answer spelling
boolean cityMatch(String input, String target) 
{
  input = input.replaceAll("\\s+", "").toLowerCase();
  target = target.replaceAll("\\s+", "").toLowerCase();
  return input.equals(target);
}

void checkAnswer() 
{
  String answer = userInput.trim();
  userInput = "";
  
  boolean alreadyUsed = false;
  for (String city : usedCities) 
  {
    if (cityMatch(answer, city)) 
    {
      alreadyUsed = true;
      break;
    }
  }
  
  if (alreadyUsed) 
  {
    score -= 1;
    return;
  }
  
  ArrayList<String> cities = tzDatabase.get(currentTZ);
  boolean correct = false;
  String matchedCity = "";
  
  if (cities != null) 
  {
    for (String city : cities) 
    {
      if (cityMatch(answer, city)) 
      {
        correct = true;
        matchedCity = city;
        break;
      }
    }
  }
  
  if (correct) 
  {
    score += 1;
    usedCities.add(matchedCity);
    minorLevel += 1;
    
    // 每完成3个小关卡，进入新的大关卡
    if (minorLevel > 3) 
    {
      majorLevel += 1;
      minorLevel = 1;
    }
    
    randomizeTimeAndZone();
  } 
  else 
  {
      score -= 1;
  }
}

void drawClock() 
{
  stroke(255);
  noFill();
  ellipse(0, 0, 300, 300);
  
  fill(255);
  for (int i = 1; i <= 12; i++) 
  {
    float angle = radians(i * 30 - 90);
    float x = cos(angle) * 120;
    float y = sin(angle) * 120;
    
    switch(majorLevel) 
    {
        case 2:
            rotate(rotation);
            rotation += 0.001;
            break;
        case 3:
            for (i = 0; i < 12; i++) 
            {
                numberSizes[i] = 24 + sin(frameCount * 0.1 + i) * 4;
            }
            break;
        case 4: 
            rotate(rotation);
            rotation += 0.001;
            for (i = 0; i < 12; i++) 
            {
                numberSizes[i] = 24 + sin(frameCount * 0.1 + i) * 4;
            }
            break;
    }
    
    text(str(i), x, y);
  }
  
  stroke(255);
  strokeWeight(4);
  
  // hour
  pushMatrix();
  rotate(radians(hour * 30 + minute() * 0.5));
  line(0, 0, 0, -60);
  popMatrix();
  
  // minite
  pushMatrix();
  rotate(radians(minute() * 6));
  line(0, 0, 0, -80);
  popMatrix();
  
  // second
  stroke(255, 0, 0);
  pushMatrix();
  rotate(radians(second() * 6));
  line(0, 0, 0, -90);
  popMatrix();
  
  // NOW
  fill(255);
  textSize(32);
  text("NOW", 0, -50);
  
  // time zone
  textSize(20);
  text(getTimezoneDisplay(currentTZ), 0, 50);
}

void keyPressed() 
{
  if (key == ENTER || key == RETURN) 
  {
    checkAnswer();
  } else if (key == BACKSPACE) 
  {
    if (userInput.length() > 0) 
    {
      userInput = userInput.substring(0, userInput.length()-1);
    }
  } 
  else if (key >= ' ' && key <= '~') 
  {
    userInput += key;
  }
}

void randomizeTimeAndZone() 
{
  Integer[] tzKeys = tzDatabase.keySet().toArray(new Integer[0]);
  currentTZ = tzKeys[int(random(tzKeys.length))];

  hour = int(random(1, 13));
}

void setupTimezoneDatabase() 
{
  // UTC+0
  ArrayList<String> utc0 = new ArrayList<String>();
  utc0.add("London"); utc0.add("Dublin"); utc0.add("Lisbon");
  utc0.add("Reykjavik"); utc0.add("Accra"); utc0.add("Casablanca");
  tzDatabase.put(0, utc0);
  
  // UTC+1
  ArrayList<String> utc1 = new ArrayList<String>();
  utc1.add("Paris"); utc1.add("Rome"); utc1.add("Berlin");
  utc1.add("Madrid"); utc1.add("Amsterdam"); utc1.add("Brussels");
  utc1.add("Vienna"); utc1.add("Warsaw"); utc1.add("Stockholm");
  utc1.add("Oslo"); utc1.add("Copenhagen"); utc1.add("Prague");
  utc1.add("Budapest"); utc1.add("Belgrade"); utc1.add("Zurich");
  tzDatabase.put(1, utc1);
  
  // UTC+2
  ArrayList<String> utc2 = new ArrayList<String>();
  utc2.add("Athens"); utc2.add("Helsinki"); utc2.add("Istanbul");
  utc2.add("Cairo"); utc2.add("Jerusalem"); utc2.add("Cape Town");
  utc2.add("Johannesburg"); utc2.add("Kiev"); utc2.add("Bucharest");
  tzDatabase.put(2, utc2);
  
  // UTC+3
  ArrayList<String> utc3 = new ArrayList<String>();
  utc3.add("Moscow"); utc3.add("Baghdad"); utc3.add("Riyadh");
  utc3.add("Nairobi"); utc3.add("Dubai"); utc3.add("Qatar");
  utc3.add("Kuwait"); utc3.add("Addis Ababa"); utc3.add("Jeddah");
  tzDatabase.put(3, utc3);
  
  // UTC+4
  ArrayList<String> utc4 = new ArrayList<String>();
  utc4.add("Baku"); utc4.add("Tbilisi"); utc4.add("Yerevan");
  utc4.add("Dubai"); utc4.add("Muscat"); utc4.add("Abu Dhabi");
  tzDatabase.put(4, utc4);
  
  // UTC+5
  ArrayList<String> utc5 = new ArrayList<String>();
  utc5.add("Karachi"); utc5.add("Tashkent"); utc5.add("Islamabad");
  utc5.add("Lahore"); utc5.add("Ashgabat"); utc5.add("Dushanbe");
  tzDatabase.put(5, utc5);
  
  // UTC+5.5
  ArrayList<String> utc55 = new ArrayList<String>();
  utc55.add("Mumbai"); utc55.add("New Delhi"); utc55.add("Kolkata");
  utc55.add("Bangalore"); utc55.add("Chennai"); utc55.add("Colombo");
  tzDatabase.put(55, utc55);
  
  // UTC+6
  ArrayList<String> utc6 = new ArrayList<String>();
  utc6.add("Dhaka"); utc6.add("Almaty"); utc6.add("Thimphu");
  utc6.add("Astana"); utc6.add("Bishkek"); utc6.add("Omsk");
  tzDatabase.put(6, utc6);
  
  // UTC+7
  ArrayList<String> utc7 = new ArrayList<String>();
  utc7.add("Bangkok"); utc7.add("Jakarta"); utc7.add("Hanoi");
  utc7.add("Phnom Penh"); utc7.add("Krasnoyarsk"); utc7.add("Ho Chi Minh");
  tzDatabase.put(7, utc7);
  
  // UTC+8
  ArrayList<String> utc8 = new ArrayList<String>();
  utc8.add("Beijing"); utc8.add("Shanghai"); utc8.add("Hong Kong");
  utc8.add("Singapore"); utc8.add("Taipei"); utc8.add("Manila");
  utc8.add("Perth"); utc8.add("Kuala Lumpur"); utc8.add("Macau");
  utc8.add("Irkutsk"); utc8.add("Bali"); utc8.add("Brunei");
  tzDatabase.put(8, utc8);
  
  // UTC+9
  ArrayList<String> utc9 = new ArrayList<String>();
  utc9.add("Tokyo"); utc9.add("Seoul"); utc9.add("Pyongyang");
  utc9.add("Sapporo"); utc9.add("Osaka"); utc9.add("Fukuoka");
  utc9.add("Yakutsk"); utc9.add("Palau"); utc9.add("Darwin");
  tzDatabase.put(9, utc9);
  
  // UTC+10
  ArrayList<String> utc10 = new ArrayList<String>();
  utc10.add("Sydney"); utc10.add("Melbourne"); utc10.add("Brisbane");
  utc10.add("Canberra"); utc10.add("Hobart"); utc10.add("Vladivostok");
  utc10.add("Port Moresby"); utc10.add("Guam");
  tzDatabase.put(10, utc10);
  
  // UTC-8
  ArrayList<String> utcm8 = new ArrayList<String>();
  utcm8.add("Los Angeles"); utcm8.add("San Francisco"); utcm8.add("Seattle");
  utcm8.add("Vancouver"); utcm8.add("Portland"); utcm8.add("Las Vegas");
  tzDatabase.put(-8, utcm8);
  
  // UTC-5
  ArrayList<String> utcm5 = new ArrayList<String>();
  utcm5.add("New York"); utcm5.add("Toronto"); utcm5.add("Miami");
  utcm5.add("Boston"); utcm5.add("Montreal"); utcm5.add("Philadelphia");
  utcm5.add("Ottawa"); utcm5.add("Havana"); utcm5.add("Nassau");
  tzDatabase.put(-5, utcm5);
}
