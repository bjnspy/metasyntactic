// Copyright 2008 Cyrus Najmabadi
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import "Model.h"

#import "Amendment.h"
#import "Article.h"
#import "Constitution.h"
#import "Decision.h"
#import "DeclarationOfIndependence.h"
#import "LocaleUtilities.h"
#import "MultiDictionary.h"
#import "Person.h"
#import "RSSCache.h"
#import "Section.h"
#import "Utilities.h"

@interface Model()
@property (retain) RSSCache* rssCache;
@end

@implementation Model

static NSArray* sectionTitles;
static NSArray* shortSectionTitles;
static NSArray* questions;
static NSArray* answers;
static NSArray* preambles;
static NSArray* otherResources;
static NSArray* sectionLinks;
static NSArray* links;

static NSArray* toughQuestions;
static NSArray* toughAnswers;

static NSString* currentVersion = @"1.4.0";

static Constitution* unitedStatesConstitution;
static Constitution* articlesOfConfederation;
static Constitution* federalistPapers;
static DeclarationOfIndependence* declarationOfIndependence;

+ (NSString*) version {
    return currentVersion;
}


Person* person(NSString* name, NSString* link) {
    return [Person personWithName:name link:link];
}


+ (void) setupToughQuestions {
    toughQuestions =
    [[NSArray arrayWithObjects:
      NSLocalizedString(@"Why do you defend Nazis and the Klan?", nil),
      NSLocalizedString(@"You’re all a bunch of liberals, aren’t you?", nil),
      NSLocalizedString(@"Why does the ACLU support cross burning?", nil),
      NSLocalizedString(@"Why does the ACLU support pornography? Why are you in favor of child porn?", nil),
      NSLocalizedString(@"Why doesn’t the ACLU support gun ownership/gun control?", nil),
      NSLocalizedString(@"Why does the ACLU support the rights of criminals but not victims of crime?", nil),
      NSLocalizedString(@"Why is the ACLU against God/Christianity/the Bible?", nil),
      NSLocalizedString(@"Why is the ACLU against drug testing of employees?", nil),
      NSLocalizedString(@"Why does the ACLU help rapists and child molesters?", nil),
      NSLocalizedString(@"Why did the ACLU defend NAMBLA?", nil), nil] retain];
    
    toughAnswers =
    [[NSArray arrayWithObjects:
      NSLocalizedString(@"The ACLU’s client is the Bill of Rights, not any particular person or group. We defend its principles – basic "
                        @"rights of citizens – whenever these are threatened. We do not believe that you can pick and chose when to "
                        @"uphold rights. If a right can be taken away from one person, it can be taken away from anyone. When you deny "
                        @"a right to someone with whom you disagree, you pave the way for that right to be denied to yourself or someone "
                        @"whom you strongly support. For example, the principle by which the Ku Klux Klan has the right to march is the "
                        @"same one that allows civil rights activists to march against racism.", nil),
      NSLocalizedString(@"The ACLU is a nonpartisan group. We have defended and worked with people all across the political spectrum, "
                        @"from Rev. Jerry Falwell and Oliver North to radio host Rush Limbaugh and former Republican member of "
                        @"Congress Bob Barr. The ACLU strongly supports women’s right to choose abortion, yet we have also assisted "
                        @"anti-abortion activists when police used excessive force in arresting them. The ACLU has won support from "
                        @"women’s groups for our stand on women’s rights, but has angered some feminists for our First Amendment "
                        @"stand on pornography.", nil),
      NSLocalizedString(@"The ACLU condemns all forms of racism. However, the ACLU does believe that in some specific cases, the "
                        @"First Amendment protects the burning of a cross. People have the right to be bigots and to make extreme, "
                        @"symbolic statements of their bigotry. Burning a cross on one’s own lawn in the middle of the day without "
                        @"making specific threats against anybody is an example of this. That’s why the ACLU opposes laws that say any "
                        @"and all instances of cross burning are illegal. Such laws are too broad and vague and have the result of "
                        @"preventing people from exercising their rights to free speech. As an answer to racist speech, the ACLU "
                        @"advocates more speech directed against racism, not the suppression of speech.", nil),
      NSLocalizedString(@"The ACLU does not support pornography. But we do oppose virtually all forms of censorship. Possessing "
                        @"books or films should not make one a criminal. Once society starts censoring “bad” ideas, it becomes very "
                        @"difficult to draw the line. Your idea of what is offensive may be a lot different from your neighbor’s. In fact, the "
                        @"ACLU does take a very purist approach in opposing censorship. Our policy is that possessing even "
                        @"pornographic material about children should not itself be a crime. The way to deal with this issue is to prosecute "
                        @"the makers of child pornography for exploiting minors.", nil),
      NSLocalizedString(@"The national ACLU is neutral on the issue of gun control. We believe the Second Amendment does not confer "
                        @"an unlimited right upon individuals to own guns or other weapons, nor does it prohibit reasonable regulation of "
                        @"gun ownership, such as licensing and registration. This, like all ACLU policies, is set by the board of directors, "
                        @"a group of ACLU members.", nil),
      NSLocalizedString(@"The ACLU supports everybody’s rights. Citizens are outraged by crime and understandably want criminals "
                        @"caught and prosecuted. The ACLU simply believes that the rights to fair treatment and due process must be "
                        @"respected for people accused of crimes. Respecting these rights does not cause crime, nor does it hinder police "
                        @"from pursuing criminals. It should, and does in fact, cause police to avoid sloppy procedures.", nil),
      NSLocalizedString(@"The ACLU strongly supports our country’s guarantee that all people have the right to practice their own "
                        @"religion, as well as the right not to practice any religion. The best way to ensure religious freedom for all is to "
                        @"keep the government out of the business of pushing religion on anybody. The ACLU strongly supports the "
                        @"separation of church and state. In practice, this means that people may practice their religion – just not with "
                        @"government funding or sponsorship. This simple principle in no way banishes or weakens religion. It only "
                        @"means that no one should have somebody else’s religion forced on him or her, even if most other people in a "
                        @"community support that religion.", nil),
      NSLocalizedString(@"The ACLU, of course, believes that employers have the right to discipline and fire workers who fail to perform "
                        @"on the job. However, the ACLU does oppose indiscriminate urine testing because the process is both unfair and "
                        @"unnecessary. Having someone urinate in a cup is a degrading and uncertain procedure that violates personal "
                        @"privacy. Further, drug tests do not measure impaired job performance. A positive drug test simply indicates that "
                        @"a person may have taken drugs at some time in the past – not that they are failing to perform properly in their "
                        @"assigned work. And the accuracy of some drug tests is notoriously unreliable. The ACLU especially objects to "
                        @"mass random drug testing of workers. There is no reason that a person should have to prove he or she is "
                        @"“innocent” of taking drugs when there is no evidence that he or she has done so. In general, what workers do off "
                        @"the job should be their own business so long as they are performing satisfactorily at work.", nil),
      NSLocalizedString(@"Of course, the ACLU supports the prosecution and conviction of rapists and child molesters. They should "
                        @"receive appropriate punishment – especially for repeat offenders. But like all convicted felons, they are entitled "
                        @"to some basic constitutional protections. In this regard the ACLU opposes the Community Protection Act "
                        @"passed by the Washington Legislature. It calls for locking up an individual indefinitely – potentially for life – "
                        @"after he has served his prison term. The punishment is based not on additional wrongful acts, but on speculation "
                        @"that the person may commit illegal acts in the future. This is unconstitutional preventive detention. It is based on "
                        @"the unscientific notion that society can predict with any reasonable standard of accuracy how a particular "
                        @"individual will act at some unspecified time.", nil),
      NSLocalizedString(@"In representing NAMBLA, the ACLU does not advocate sexual relationships between adults and children. In "
                        @"celebrated cases, the ACLU has stood up for everyone from Oliver North to the National Socialist Party. In "
                        @"spite of all that, the ACLU has never advocated Christianity, ritual animal sacrifice, trading arms for hostages or "
                        @"genocide. What we do advocate is robust freedom of speech. This lawsuit strikes at the heart of freedom of "
                        @"speech. The defense of freedom of speech is most critical when the message is one most people find repulsive. "
                        @"The case is based on a shocking murder. But the lawsuit says the crime is the responsibility not of those who "
                        @"committed the murder, but of someone who posted vile material on the Internet. The principle is as simple as it "
                        @"is central to true freedom of speech: those who do wrong are responsible for what they do; those who speak "
                        @"about it are not. It is easy to defend freedom of speech when the message is something many people find at least "
                        @"reasonable. But the defense of freedom of speech is most critical when the message is one most people find "
                        @"repulsive. That was true when the Nazis marched in Skokie. It remains true today.", nil), nil] retain];
}


+ (Constitution*) setupUnitedStatesConstitution {
    NSString* country = [[NSLocale currentLocale] displayNameForKey:NSLocaleCountryCode value:@"US"];
    Article* article1 =
    [Article articleWithTitle:NSLocalizedString(@"The Legislative Branch", nil)
                         link:@"http://en.wikipedia.org/wiki/Article_One_of_the_United_States_Constitution"
                     sections:[NSArray arrayWithObjects:
                               [Section sectionWithText:NSLocalizedString(@"All legislative powers herein granted shall be vested in a Congress of the United States, which shall consist of a Senate and House of Representatives.", nil)],
                               [Section sectionWithText:NSLocalizedString(@"The House of Representatives shall be composed of members chosen every second year by the people of the several states, and the electors in each state shall have the qualifications requisite for electors of the most numerous branch of the state legislature.\n\n"
                                                                          @"No person shall be a Representative who shall not have attained to the age of twenty five years, and been seven years a citizen of the United States, and who shall not, when elected, be an inhabitant of that state in which he shall be chosen.\n\n"
                                                                          @"Representatives and direct taxes shall be apportioned among the several states which may be included within this union, according to their respective numbers, which shall be determined by adding to the whole number of free persons, including those bound to service for a term of years, and excluding Indians not taxed, three fifths of all other Persons. The actual Enumeration shall be made within three years after the first meeting of the Congress of the United States, and within every subsequent term of ten years, in such manner as they shall by law direct. The number of Representatives shall not exceed one for every thirty thousand, but each state shall have at least one Representative; and until such enumeration shall be made, the state of New Hampshire shall be entitled to chuse three, Massachusetts eight, Rhode Island and Providence Plantations one, Connecticut five, New York six, New Jersey four, Pennsylvania eight, Delaware one, Maryland six, Virginia ten, North Carolina five, South Carolina five, and Georgia three.\n\n"
                                                                          @"When vacancies happen in the Representation from any state, the executive authority thereof shall issue writs of election to fill such vacancies.\n\n"
                                                                          @"The House of Representatives shall choose their speaker and other officers; and shall have the sole power of impeachment.", nil)],
                               [Section sectionWithText:NSLocalizedString(@"The Senate of the United States shall be composed of two Senators from each state, chosen by the legislature thereof, for six years; and each Senator shall have one vote.\n\n"
                                                                          @"Immediately after they shall be assembled in consequence of the first election, they shall be divided as equally as may be into three classes. The seats of the Senators of the first class shall be vacated at the expiration of the second year, of the second class at the expiration of the fourth year, and the third class at the expiration of the sixth year, so that one third may be chosen every second year; and if vacancies happen by resignation, or otherwise, during the recess of the legislature of any state, the executive thereof may make temporary appointments until the next meeting of the legislature, which shall then fill such vacancies.\n\n"
                                                                          @"No person shall be a Senator who shall not have attained to the age of thirty years, and been nine years a citizen of the United States and who shall not, when elected, be an inhabitant of that state for which he shall be chosen.\n\n"
                                                                          @"The Vice President of the United States shall be President of the Senate, but shall have no vote, unless they be equally divided.\n\n"
                                                                          @"The Senate shall choose their other officers, and also a President pro tempore, in the absence of the Vice President, or when he shall exercise the office of President of the United States.\n\n"
                                                                          @"The Senate shall have the sole power to try all impeachments. When sitting for that purpose, they shall be on oath or affirmation. When the President of the United States is tried, the Chief Justice shall preside: And no person shall be convicted without the concurrence of two thirds of the members present.\n\n"
                                                                          @"Judgment in cases of impeachment shall not extend further than to removal from office, and disqualification to hold and enjoy any office of honor, trust or profit under the United States: but the party convicted shall nevertheless be liable and subject to indictment, trial, judgment and punishment, according to law.", nil)],
                               [Section sectionWithText:NSLocalizedString(@"The times, places and manner of holding elections for Senators and Representatives, shall be prescribed in each state by the legislature thereof; but the Congress may at any time by law make or alter such regulations, except as to the places of choosing Senators.\n\n"
                                                                          @"The Congress shall assemble at least once in every year, and such meeting shall be on the first Monday in December, unless they shall by law appoint a different day.", nil)],
                               [Section sectionWithText:NSLocalizedString(@"Each House shall be the judge of the elections, returns and qualifications of its own members, and a majority of each shall constitute a quorum to do business; but a smaller number may adjourn from day to day, and may be authorized to compel the attendance of absent members, in such manner, and under such penalties as each House may provide.\n\n"
                                                                          @"Each House may determine the rules of its proceedings, punish its members for disorderly behavior, and, with the concurrence of two thirds, expel a member.\n\n"
                                                                          @"Each House shall keep a journal of its proceedings, and from time to time publish the same, excepting such parts as may in their judgment require secrecy; and the yeas and nays of the members of either House on any question shall, at the desire of one fifth of those present, be entered on the journal.\n\n"
                                                                          @"Neither House, during the session of Congress, shall, without the consent of the other, adjourn for more than three days, nor to any other place than that in which the two Houses shall be sitting.", nil)],
                               [Section sectionWithText:NSLocalizedString(@"The Senators and Representatives shall receive a compensation for their services, to be ascertained by law, and paid out of the treasury of the United States. They shall in all cases, except treason, felony and breach of the peace, be privileged from arrest during their attendance at the session of their respective Houses, and in going to and returning from the same; and for any speech or debate in either House, they shall not be questioned in any other place.\n\n"
                                                                          @"No Senator or Representative shall, during the time for which he was elected, be appointed to any civil office under the authority of the United States, which shall have been created, or the emoluments whereof shall have been increased during such time: and no person holding any office under the United States, shall be a member of either House during his continuance in office.", nil)],
                               [Section sectionWithText:NSLocalizedString(@"All bills for raising revenue shall originate in the House of Representatives; but the Senate may propose or concur with amendments as on other Bills.\n\n"
                                                                          @"Every bill which shall have passed the House of Representatives and the Senate, shall, before it become a law, be presented to the President of the United States; if he approve he shall sign it, but if not he shall return it, with his objections to that House in which it shall have originated, who shall enter the objections at large on their journal, and proceed to reconsider it. If after such reconsideration two thirds of that House shall agree to pass the bill, it shall be sent, together with the objections, to the other House, by which it shall likewise be reconsidered, and if approved by two thirds of that House, it shall become a law. But in all such cases the votes of both Houses shall be determined by yeas and nays, and the names of the persons voting for and against the bill shall be entered on the journal of each House respectively. If any bill shall not be returned by the President within ten days (Sundays excepted) after it shall have been presented to him, the same shall be a law, in like manner as if he had signed it, unless the Congress by their adjournment prevent its return, in which case it shall not be a law.\n\n"
                                                                          @"Every order, resolution, or vote to which the concurrence of the Senate and House of Representatives may be necessary (except on a question of adjournment) shall be presented to the President of the United States; and before the same shall take effect, shall be approved by him, or being disapproved by him, shall be repassed by two thirds of the Senate and House of Representatives, according to the rules and limitations prescribed in the case of a bill.", nil)],
                               [Section sectionWithText:NSLocalizedString(@"The Congress shall have power to lay and collect taxes, duties, imposts and excises, to pay the debts and provide for the common defense and general welfare of the United States; but all duties, imposts and excises shall be uniform throughout the United States;\n\n"
                                                                          @"To borrow money on the credit of the United States;\n\n"
                                                                          @"To regulate commerce with foreign nations, and among the several states, and with the Indian tribes;\n\n"
                                                                          @"To establish a uniform rule of naturalization, and uniform laws on the subject of bankruptcies throughout the United States;\n\n"
                                                                          @"To coin money, regulate the value thereof, and of foreign coin, and fix the standard of weights and measures;\n\n"
                                                                          @"To provide for the punishment of counterfeiting the securities and current coin of the United States;\n\n"
                                                                          @"To establish post offices and post roads;\n\n"
                                                                          @"To promote the progress of science and useful arts, by securing for limited times to authors and inventors the exclusive right to their respective writings and discoveries;\n\n"
                                                                          @"To constitute tribunals inferior to the Supreme Court;\n\n"
                                                                          @"To define and punish piracies and felonies committed on the high seas, and offenses against the law of nations;\n\n"
                                                                          @"To declare war, grant letters of marque and reprisal, and make rules concerning captures on land and water;\n\n"
                                                                          @"To raise and support armies, but no appropriation of money to that use shall be for a longer term than two years;\n\n"
                                                                          @"To provide and maintain a navy;\n\n"
                                                                          @"To make rules for the government and regulation of the land and naval forces;\n\n"
                                                                          @"To provide for calling forth the militia to execute the laws of the union, suppress insurrections and repel invasions;\n\n"
                                                                          @"To provide for organizing, arming, and disciplining, the militia, and for governing such part of them as may be employed in the service of the United States, reserving to the states respectively, the appointment of the officers, and the authority of training the militia according to the discipline prescribed by Congress;\n\n"
                                                                          @"To exercise exclusive legislation in all cases whatsoever, over such District (not exceeding ten miles square) as may, by cession of particular states, and the acceptance of Congress, become the seat of the government of the United States, and to exercise like authority over all places purchased by the consent of the legislature of the state in which the same shall be, for the erection of forts, magazines, arsenals, dockyards, and other needful buildings;--And\n\n"
                                                                          @"To make all laws which shall be necessary and proper for carrying into execution the foregoing powers, and all other powers vested by this Constitution in the government of the United States, or in any department or officer thereof.", nil)],
                               [Section sectionWithText:NSLocalizedString(@"The migration or importation of such persons as any of the states now existing shall think proper to admit, shall not be prohibited by the Congress prior to the year one thousand eight hundred and eight, but a tax or duty may be imposed on such importation, not exceeding ten dollars for each person.\n\n"
                                                                          @"The privilege of the writ of habeas corpus shall not be suspended, unless when in cases of rebellion or invasion the public safety may require it.\n\n"
                                                                          @"No bill of attainder or ex post facto Law shall be passed.\n\n"
                                                                          @"No capitation, or other direct, tax shall be laid, unless in proportion to the census or enumeration herein before directed to be taken.\n\n"
                                                                          @"No tax or duty shall be laid on articles exported from any state.\n\n"
                                                                          @"No preference shall be given by any regulation of commerce or revenue to the ports of one state over those of another: nor shall vessels bound to, or from, one state, be obliged to enter, clear or pay duties in another.\n\n"
                                                                          @"No money shall be drawn from the treasury, but in consequence of appropriations made by law; and a regular statement and account of receipts and expenditures of all public money shall be published from time to time.\n\n"
                                                                          @"No title of nobility shall be granted by the United States: and no person holding any office of profit or trust under them, shall, without the consent of the Congress, accept of any present, emolument, office, or title, of any kind whatever, from any king, prince, or foreign state.", nil)],
                               [Section sectionWithText:NSLocalizedString(@"No state shall enter into any treaty, alliance, or confederation; grant letters of marque and reprisal; coin money; emit bills of credit; make anything but gold and silver coin a tender in payment of debts; pass any bill of attainder, ex post facto law, or law impairing the obligation of contracts, or grant any title of nobility.\n\n"
                                                                          @"No state shall, without the consent of the Congress, lay any imposts or duties on imports or exports, except what may be absolutely necessary for executing it's inspection laws: and the net produce of all duties and imposts, laid by any state on imports or exports, shall be for the use of the treasury of the United States; and all such laws shall be subject to the revision and control of the Congress.\n\n"
                                                                          @"No state shall, without the consent of Congress, lay any duty of tonnage, keep troops, or ships of war in time of peace, enter into any agreement or compact with another state, or with a foreign power, or engage in war, unless actually invaded, or in such imminent danger as will not admit of delay.", nil)], nil]];
    
    Article* article2 =
    [Article articleWithTitle:NSLocalizedString(@"The Presidency", nil)
                         link:@"http://en.wikipedia.org/wiki/Article_Two_of_the_United_States_Constitution"
                     sections:[NSArray arrayWithObjects:
                               [Section sectionWithText:NSLocalizedString(@"The executive power shall be vested in a President of the United States of America. He shall hold his office during the term of four years, and, together with the Vice President, chosen for the same term, be elected, as follows:\n\n"
                                                                          @"Each state shall appoint, in such manner as the Legislature thereof may direct, a number of electors, equal to the whole number of Senators and Representatives to which the State may be entitled in the Congress: but no Senator or Representative, or person holding an office of trust or profit under the United States, shall be appointed an elector.\n\n"
                                                                          @"The electors shall meet in their respective states, and vote by ballot for two persons, of whom one at least shall not be an inhabitant of the same state with themselves. And they shall make a list of all the persons voted for, and of the number of votes for each; which list they shall sign and certify, and transmit sealed to the seat of the government of the United States, directed to the President of the Senate. The President of the Senate shall, in the presence of the Senate and House of Representatives, open all the certificates, and the votes shall then be counted. The person having the greatest number of votes shall be the President, if such number be a majority of the whole number of electors appointed; and if there be more than one who have such majority, and have an equal number of votes, then the House of Representatives shall immediately choose by ballot one of them for President; and if no person have a majority, then from the five highest on the list the said House shall in like manner choose the President. But in choosing the President, the votes shall be taken by States, the representation from each state having one vote; A quorum for this purpose shall consist of a member or members from two thirds of the states, and a majority of all the states shall be necessary to a choice. In every case, after the choice of the President, the person having the greatest number of votes of the electors shall be the Vice President. But if there should remain two or more who have equal votes, the Senate shall choose from them by ballot the Vice President.\n\n"
                                                                          @"The Congress may determine the time of choosing the electors, and the day on which they shall give their votes; which day shall be the same throughout the United States.\n\n"
                                                                          @"No person except a natural born citizen, or a citizen of the United States, at the time of the adoption of this Constitution, shall be eligible to the office of President; neither shall any person be eligible to that office who shall not have attained to the age of thirty five years, and been fourteen Years a resident within the United States.\n\n"
                                                                          @"In case of the removal of the President from office, or of his death, resignation, or inability to discharge the powers and duties of the said office, the same shall devolve on the Vice President, and the Congress may by law provide for the case of removal, death, resignation or inability, both of the President and Vice President, declaring what officer shall then act as President, and such officer shall act accordingly, until the disability be removed, or a President shall be elected.\n\n"
                                                                          @"The President shall, at stated times, receive for his services, a compensation, which shall neither be increased nor diminished during the period for which he shall have been elected, and he shall not receive within that period any other emolument from the United States, or any of them.\n\n"
                                                                          @"Before he enter on the execution of his office, he shall take the following oath or affirmation:--'I do solemnly swear (or affirm) that I will faithfully execute the office of President of the United States, and will to the best of my ability, preserve, protect and defend the Constitution of the United States.'", nil)],           
                               [Section sectionWithText:NSLocalizedString(@"The President shall be commander in chief of the Army and Navy of the United States, and of the militia of the several states, when called into the actual service of the United States; he may require the opinion, in writing, of the principal officer in each of the executive departments, upon any subject relating to the duties of their respective offices, and he shall have power to grant reprieves and pardons for offenses against the United States, except in cases of impeachment.\n\n"
                                                                          @"He shall have power, by and with the advice and consent of the Senate, to make treaties, provided two thirds of the Senators present concur; and he shall nominate, and by and with the advice and consent of the Senate, shall appoint ambassadors, other public ministers and consuls, judges of the Supreme Court, and all other officers of the United States, whose appointments are not herein otherwise provided for, and which shall be established by law: but the Congress may by law vest the appointment of such inferior officers, as they think proper, in the President alone, in the courts of law, or in the heads of departments.\n\n"
                                                                          @"The President shall have power to fill up all vacancies that may happen during the recess of the Senate, by granting commissions which shall expire at the end of their next session.", nil)],
                               [Section sectionWithText:NSLocalizedString(@"He shall from time to time give to the Congress information of the state of the union, and recommend to their consideration such measures as he shall judge necessary and expedient; he may, on extraordinary occasions, convene both Houses, or either of them, and in case of disagreement between them, with respect to the time of adjournment, he may adjourn them to such time as he shall think proper; he shall receive ambassadors and other public ministers; he shall take care that the laws be faithfully executed, and shall commission all the officers of the United States.", nil)], 
                               [Section sectionWithText:NSLocalizedString(@"The President, Vice President and all civil officers of the United States, shall be removed from office on impeachment for, and conviction of, treason, bribery, or other high crimes and misdemeanors.", nil)], nil]];
    
    Article* article3 =
    [Article articleWithTitle:NSLocalizedString(@"The Judiciary", nil)
                         link:@"http://en.wikipedia.org/wiki/Article_Three_of_the_United_States_Constitution"
                     sections:[NSArray arrayWithObjects:
                               [Section sectionWithText:NSLocalizedString(@"The judicial power of the United States, shall be vested in one Supreme Court, and in such inferior courts as the Congress may from time to time ordain and establish. The judges, both of the supreme and inferior courts, shall hold their offices during good behaviour, and shall, at stated times, receive for their services, a compensation, which shall not be diminished during their continuance in office.", nil)],
                               [Section sectionWithText:NSLocalizedString(@"The judicial power shall extend to all cases, in law and equity, arising under this Constitution, the laws of the United States, and treaties made, or which shall be made, under their authority;--to all cases affecting ambassadors, other public ministers and consuls;--to all cases of admiralty and maritime jurisdiction;--to controversies to which the United States shall be a party;--to controversies between two or more states;--between a state and citizens of another state;--between citizens of different states;--between citizens of the same state claiming lands under grants of different states, and between a state, or the citizens thereof, and foreign states, citizens or subjects.\n\n"
                                                                          @"In all cases affecting ambassadors, other public ministers and consuls, and those in which a state shall be party, the Supreme Court shall have original jurisdiction. In all the other cases before mentioned, the Supreme Court shall have appellate jurisdiction, both as to law and fact, with such exceptions, and under such regulations as the Congress shall make.\n\n"
                                                                          @"The trial of all crimes, except in cases of impeachment, shall be by jury; and such trial shall be held in the state where the said crimes shall have been committed; but when not committed within any state, the trial shall be at such place or places as the Congress may by law have directed.", nil)],
                               [Section sectionWithText:NSLocalizedString(@"Treason against the United States, shall consist only in levying war against them, or in adhering to their enemies, giving them aid and comfort. No person shall be convicted of treason unless on the testimony of two witnesses to the same overt act, or on confession in open court.\n\n"
                                                                          @"The Congress shall have power to declare the punishment of treason, but no attainder of treason shall work corruption of blood, or forfeiture except during the life of the person attainted.", nil)],
                               nil]];
    
    Article* article4 =
    [Article articleWithTitle:NSLocalizedString(@"The States", nil)
                         link:@"http://en.wikipedia.org/wiki/Article_Four_of_the_United_States_Constitution"
                     sections:[NSArray arrayWithObjects:
                               [Section sectionWithText:NSLocalizedString(@"Full faith and credit shall be given in each state to the public acts, records, and judicial proceedings of every other state. And the Congress may by general laws prescribe the manner in which such acts, records, and proceedings shall be proved, and the effect thereof.", nil)],
                               [Section sectionWithText:NSLocalizedString(@"The citizens of each state shall be entitled to all privileges and immunities of citizens in the several states.\n\n"
                                                                          @"A person charged in any state with treason, felony, or other crime, who shall flee from justice, and be found in another state, shall on demand of the executive authority of the state from which he fled, be delivered up, to be removed to the state having jurisdiction of the crime.\n\n"
                                                                          @"No person held to service or labor in one state, under the laws thereof, escaping into another, shall, in consequence of any law or regulation therein, be discharged from such service or labor, but shall be delivered up on claim of the party to whom such service or labor may be due.", nil)],
                               [Section sectionWithText:NSLocalizedString(@"New states may be admitted by the Congress into this union; but no new states shall be formed or erected within the jurisdiction of any other state; nor any state be formed by the junction of two or more states, or parts of states, without the consent of the legislatures of the states concerned as well as of the Congress.\n\n"
                                                                          @"The Congress shall have power to dispose of and make all needful rules and regulations respecting the territory or other property belonging to the United States; and nothing in this Constitution shall be so construed as to prejudice any claims of the United States, or of any particular state.", nil)],
                               [Section sectionWithText:NSLocalizedString(@"The United States shall guarantee to every state in this union a republican form of government, and shall protect each of them against invasion; and on application of the legislature, or of the executive (when the legislature cannot be convened) against domestic violence.", nil)],
                               nil]];
    
    Article* article5 =
    [Article articleWithTitle:NSLocalizedString(@"The Amendment Process", nil)
                         link:@"http://en.wikipedia.org/wiki/Article_Five_of_the_United_States_Constitution"
                      section:[Section sectionWithText:NSLocalizedString(@"The Congress, whenever two thirds of both houses shall deem it necessary, shall propose amendments to this Constitution, or, on the application of the legislatures of two thirds of the several states, shall call a convention for proposing amendments, which, in either case, shall be valid to all intents and purposes, as part of this Constitution, when ratified by the legislatures of three fourths of the several states, or by conventions in three fourths thereof, as the one or the other mode of ratification may be proposed by the Congress; provided that no amendment which may be made prior to the year one thousand eight hundred and eight shall in any manner affect the first and fourth clauses in the ninth section of the first article; and that no state, without its consent, shall be deprived of its equal suffrage in the Senate.", nil)]];
    
    Article* article6 =
    [Article articleWithTitle:NSLocalizedString(@"Legal Status of the Constitution", nil)
                         link:@"http://en.wikipedia.org/wiki/Article_Six_of_the_United_States_Constitution"
                      section:[Section sectionWithText:NSLocalizedString(@"All debts contracted and engagements entered into, before the adoption of this Constitution, shall be as valid against the United States under this Constitution, as under the Confederation.\n\n"
                                                                         @"This Constitution, and the laws of the United States which shall be made in pursuance thereof; and all treaties made, or which shall be made, under the authority of the United States, shall be the supreme law of the land; and the judges in every state shall be bound thereby, anything in the Constitution or laws of any State to the contrary notwithstanding.\n\n"
                                                                         @"The Senators and Representatives before mentioned, and the members of the several state legislatures, and all executive and judicial officers, both of the United States and of the several states, shall be bound by oath or affirmation, to support this Constitution; but no religious test shall ever be required as a qualification to any office or public trust under the United States.", nil)]];
    
    Article* article7 =
    [Article articleWithTitle:NSLocalizedString(@"Ratification", nil)
                         link:@"http://en.wikipedia.org/wiki/Article_Seven_of_the_United_States_Constitution"
                      section:[Section sectionWithText:NSLocalizedString(@"The ratification of the conventions of nine states, shall be sufficient for the establishment of this Constitution between the states so ratifying the same.", nil)]];
    
    Amendment* amendment1 =
    [Amendment amendmentWithSynopsis:NSLocalizedString(@"Religion, Speech, Press", nil)
                                year:1791
                                link:@"http://en.wikipedia.org/wiki/First_Amendment_to_the_United_States_Constitution"
                                text:NSLocalizedString(@"Congress shall make no law respecting an establishment of religion, or prohibiting the free exercise thereof; or abridging the freedom of speech, or of the press; or the right of the people peaceably to assemble, and to petition the government for a redress of grievances.", nil)];
    Amendment* amendment2 =
    [Amendment amendmentWithSynopsis:NSLocalizedString(@"Right to Bear Arms", nil)
                                year:1791
                                link:@"http://en.wikipedia.org/wiki/Second_Amendment_to_the_United_States_Constitution"
                                text:NSLocalizedString(@"A well regulated militia, being necessary to the security of a free state, the right of the people to keep and bear arms, shall not be infringed.", nil)];
    Amendment* amendment3 =
    [Amendment amendmentWithSynopsis:NSLocalizedString(@"Quartering of Troops", nil)
                                year:1791
                                link:@"http://en.wikipedia.org/wiki/Third_Amendment_to_the_United_States_Constitution"
                                text:NSLocalizedString(@"No soldier shall, in time of peace be quartered in any house, without the consent of the owner, nor in time of war, but in a manner to be prescribed by law.", nil)];
    Amendment* amendment4 =
    [Amendment amendmentWithSynopsis:NSLocalizedString(@"Search and Seizure", nil)
                                year:1791
                                link:@"http://en.wikipedia.org/wiki/Fourth_Amendment_to_the_United_States_Constitution"
                                text:NSLocalizedString(@"The right of the people to be secure in their persons, houses, papers, and effects, against unreasonable searches and seizures, shall not be violated, and no warrants shall issue, but upon probable cause, supported by oath or affirmation, and particularly describing the place to be searched, and the persons or things to be seized.", nil)];
    Amendment* amendment5 =
    [Amendment amendmentWithSynopsis:NSLocalizedString(@"Due Process", nil)
                                year:1791
                                link:@"http://en.wikipedia.org/wiki/Fifth_Amendment_to_the_United_States_Constitution"
                                text:NSLocalizedString(@"No person shall be held to answer for a capital, or otherwise infamous crime, unless on a presentment or indictment of a grand jury, except in cases arising in the land or naval forces, or in the militia, when in actual service in time of war or public danger; nor shall any person be subject for the same offense to be twice put in jeopardy of life or limb; nor shall be compelled in any criminal case to be a witness against himself, nor be deprived of life, liberty, or property, without due process of law; nor shall private property be taken for public use, without just compensation.", nil)];
    Amendment* amendment6 =
    [Amendment amendmentWithSynopsis:NSLocalizedString(@"Right to Counsel", nil)
                                year:1791
                                link:@"http://en.wikipedia.org/wiki/Sixth_Amendment_to_the_United_States_Constitution"
                                text:NSLocalizedString(@"In all criminal prosecutions, the accused shall enjoy the right to a speedy and public trial, by an impartial jury of the state and district wherein the crime shall have been committed, which district shall have been previously ascertained by law, and to be informed of the nature and cause of the accusation; to be confronted with the witnesses against him; to have compulsory process for obtaining witnesses in his favor, and to have the assistance of counsel for his defense.", nil)];
    Amendment* amendment7 =
    [Amendment amendmentWithSynopsis:NSLocalizedString(@"Jury Trial", nil)
                                year:1791
                                link:@"http://en.wikipedia.org/wiki/Seventh_Amendment_to_the_United_States_Constitution"
                                text:NSLocalizedString(@"In suits at common law, where the value in controversy shall exceed twenty dollars, the right of trial by jury shall be preserved, and no fact tried by a jury, shall be otherwise reexamined in any court of the United States, than according to the rules of the common law.", nil)];
    Amendment* amendment8 =
    [Amendment amendmentWithSynopsis:NSLocalizedString(@"Cruel and Unusual Punishment", nil)
                                year:1791
                                link:@"http://en.wikipedia.org/wiki/Eighth_Amendment_to_the_United_States_Constitution"
                                text:NSLocalizedString(@"Excessive bail shall not be required, nor excessive fines imposed, nor cruel and unusual punishments inflicted.", nil)];
    Amendment* amendment9 =
    [Amendment amendmentWithSynopsis:NSLocalizedString(@"Non-Enumerated Rights", nil)
                                year:1791
                                link:@"http://en.wikipedia.org/wiki/Ninth_Amendment_to_the_United_States_Constitution"
                                text:NSLocalizedString(@"The enumeration in the Constitution, of certain rights, shall not be construed to deny or disparage others retained by the people.", nil)];
    Amendment* amendment10 =
    [Amendment amendmentWithSynopsis:NSLocalizedString(@"States Rights", nil)
                                year:1791
                                link:@"http://en.wikipedia.org/wiki/Tenth_Amendment_to_the_United_States_Constitution"
                                text:NSLocalizedString(@"The powers not delegated to the United States by the Constitution, nor prohibited by it to the states, are reserved to the states respectively, or to the people.", nil)];
    Amendment* amendment11 =
    [Amendment amendmentWithSynopsis:NSLocalizedString(@"Suits Against a State", nil)
                                year:1795
                                link:@"http://en.wikipedia.org/wiki/Eleventh_Amendment_to_the_United_States_Constitution"
                                text:NSLocalizedString(@"The judicial power of the United States shall not be construed to extend to any suit in law or equity, commenced or prosecuted against one of the United States by citizens of another state, or by citizens or subjects of any foreign state.", nil)];
    Amendment* amendment12 =
    [Amendment amendmentWithSynopsis:NSLocalizedString(@"President and VP Election", nil)
                                year:1804
                                link:@"http://en.wikipedia.org/wiki/Twelfth_Amendment_to_the_United_States_Constitution"
                                text:NSLocalizedString(@"The electors shall meet in their respective states and vote by ballot for President and Vice-President, one of whom, at least, shall not be an inhabitant of the same state with themselves; they shall name in their ballots the person voted for as President, and in distinct ballots the person voted for as Vice-President, and they shall make distinct lists of all persons voted for as President, and of all persons voted for as Vice-President, and of the number of votes for each, which lists they shall sign and certify, and transmit sealed to the seat of the government of the United States, directed to the President of the Senate;--The President of the Senate shall, in the presence of the Senate and House of Representatives, open all the certificates and the votes shall then be counted;--the person having the greatest number of votes for President, shall be the President, if such number be a majority of the whole number of electors appointed; and if no person have such majority, then from the persons having the highest numbers not exceeding three on the list of those voted for as President, the House of Representatives shall choose immediately, by ballot, the President. But in choosing the President, the votes shall be taken by states, the representation from each state having one vote; a quorum for this purpose shall consist of a member or members from two-thirds of the states, and a majority of all the states shall be necessary to a choice. And if the House of Representatives shall not choose a President whenever the right of choice shall devolve upon them, before the fourth day of March next following, then the Vice-President shall act as President, as in the case of the death or other constitutional disability of the President. The person having the greatest number of votes as Vice-President, shall be the Vice-President, if such number be a majority of the whole number of electors appointed, and if no person have a majority, then from the two highest numbers on the list, the Senate shall choose the Vice-President; a quorum for the purpose shall consist of two-thirds of the whole number of Senators, and a majority of the whole number shall be necessary to a choice. But no person constitutionally ineligible to the office of President shall be eligible to that of Vice-President of the United States.", nil)];
    Amendment* amendment13 =
    [Amendment amendmentWithSynopsis:NSLocalizedString(@"Abolition of Slavery", nil)
                                year:1865
                                link:@"http://en.wikipedia.org/wiki/Thirteenth_Amendment_to_the_United_States_Constitution"
                            sections:[NSArray arrayWithObjects:
                                      [Section sectionWithText:NSLocalizedString(@"Neither slavery nor involuntary servitude, except as a punishment for crime whereof the party shall have been duly convicted, shall exist within the United States, or any place subject to their jurisdiction.", nil)],
                                      [Section sectionWithText:NSLocalizedString(@"Congress shall have power to enforce this article by appropriate legislation.", nil)], nil]];
    Amendment* amendment14 =
    [Amendment amendmentWithSynopsis:NSLocalizedString(@"Equal Protection", nil)
                                year:1868
                                link:@"http://en.wikipedia.org/wiki/Fourteenth_Amendment_to_the_United_States_Constitution"
                            sections:[NSArray arrayWithObjects:
                                      [Section sectionWithText:NSLocalizedString(@"All persons born or naturalized in the United States, and subject to the jurisdiction thereof, are citizens of the United States and of the state wherein they reside. No state shall make or enforce any law which shall abridge the privileges or immunities of citizens of the United States; nor shall any state deprive any person of life, liberty, or property, without due process of law; nor deny to any person within its jurisdiction the equal protection of the laws.", nil)],
                                      [Section sectionWithText:NSLocalizedString(@"Representatives shall be apportioned among the several states according to their respective numbers, counting the whole number of persons in each state, excluding Indians not taxed. But when the right to vote at any election for the choice of electors for President and Vice President of the United States, Representatives in Congress, the executive and judicial officers of a state, or the members of the legislature thereof, is denied to any of the male inhabitants of such state, being twenty-one years of age, and citizens of the United States, or in any way abridged, except for participation in rebellion, or other crime, the basis of representation therein shall be reduced in the proportion which the number of such male citizens shall bear to the whole number of male citizens twenty-one years of age in such state.", nil)],
                                      [Section sectionWithText:NSLocalizedString(@"No person shall be a Senator or Representative in Congress, or elector of President and Vice President, or hold any office, civil or military, under the United States, or under any state, who, having previously taken an oath, as a member of Congress, or as an officer of the United States, or as a member of any state legislature, or as an executive or judicial officer of any state, to support the Constitution of the United States, shall have engaged in insurrection or rebellion against the same, or given aid or comfort to the enemies thereof. But Congress may by a vote of two-thirds of each House, remove such disability.", nil)],
                                      [Section sectionWithText:NSLocalizedString(@"The validity of the public debt of the United States, authorized by law, including debts incurred for payment of pensions and bounties for services in suppressing insurrection or rebellion, shall not be questioned. But neither the United States nor any state shall assume or pay any debt or obligation incurred in aid of insurrection or rebellion against the United States, or any claim for the loss or emancipation of any slave; but all such debts, obligations and claims shall be held illegal and void.", nil)],
                                      [Section sectionWithText:NSLocalizedString(@"The Congress shall have power to enforce, by appropriate legislation, the provisions of this article.", nil)], nil]];
    Amendment* amendment15 =
    [Amendment amendmentWithSynopsis:NSLocalizedString(@"Race Rights", nil)
                                year:1870
                                link:@"http://en.wikipedia.org/wiki/Fifteenth_Amendment_to_the_United_States_Constitution"
                            sections:[NSArray arrayWithObjects:
                                      [Section sectionWithText:NSLocalizedString(@"The right of citizens of the United States to vote shall not be denied or abridged by the United States or by any state on account of race, color, or previous condition of servitude.", nil)],
                                      [Section sectionWithText:NSLocalizedString(@"The Congress shall have power to enforce this article by appropriate legislation.", nil)], nil]];
    Amendment* amendment16 =
    [Amendment amendmentWithSynopsis:NSLocalizedString(@"Income Tax", nil)
                                year:1913
                                link:@"http://en.wikipedia.org/wiki/Sixteenth_Amendment_to_the_United_States_Constitution"
                                text:NSLocalizedString(@"The Congress shall have power to lay and collect taxes on incomes, from whatever source derived, without apportionment among the several states, and without regard to any census or enumeration.", nil)];
    Amendment* amendment17 =
    [Amendment amendmentWithSynopsis:NSLocalizedString(@"Election of Senators", nil)
                                year:1913
                                link:@"http://en.wikipedia.org/wiki/Seventeenth_Amendment_to_the_United_States_Constitution"
                                text:NSLocalizedString(@"The Senate of the United States shall be composed of two Senators from each state, elected by the people thereof, for six years; and each Senator shall have one vote. The electors in each state shall have the qualifications requisite for electors of the most numerous branch of the state legislatures.\n\n"
                                                       @"When vacancies happen in the representation of any state in the Senate, the executive authority of such state shall issue writs of election to fill such vacancies: Provided, that the legislature of any state may empower the executive thereof to make temporary appointments until the people fill the vacancies by election as the legislature may direct.\n\n"
                                                       @"This amendment shall not be so construed as to affect the election or term of any Senator chosen before it becomes valid as part of the Constitution.", nil)];
    Amendment* amendment18 =
    [Amendment amendmentWithSynopsis:NSLocalizedString(@"Prohibition", nil)
                                year:1919
                                link:@"http://en.wikipedia.org/wiki/Eighteenth_Amendment_to_the_United_States_Constitution"
                            sections:[NSArray arrayWithObjects:
                                      [Section sectionWithText:NSLocalizedString(@"After one year from the ratification of this article the manufacture, sale, or transportation of intoxicating liquors within, the importation thereof into, or the exportation thereof from the United States and all territory subject to the jurisdiction thereof for beverage purposes is hereby prohibited.", nil)],
                                      [Section sectionWithText:NSLocalizedString(@"The Congress and the several states shall have concurrent power to enforce this article by appropriate legislation.", nil)],
                                      [Section sectionWithText:NSLocalizedString(@"This article shall be inoperative unless it shall have been ratified as an amendment to the Constitution by the legislatures of the several states, as provided in the Constitution, within seven years from the date of the submission hereof to the states by the Congress.", nil)], nil]];
    Amendment* amendment19 =
    [Amendment amendmentWithSynopsis:NSLocalizedString(@"Women's Rights", nil)
                                year:1920
                                link:@"http://en.wikipedia.org/wiki/Nineteenth_Amendment_to_the_United_States_Constitution"
                                text:NSLocalizedString(@"The right of citizens of the United States to vote shall not be denied or abridged by the United States or by any state on account of sex.\n\n"
                                                       @"Congress shall have power to enforce this article by appropriate legislation.", nil)];
    Amendment* amendment20 =
    [Amendment amendmentWithSynopsis:NSLocalizedString(@"Presidential Succession", nil)
                                year:1933
                                link:@"http://en.wikipedia.org/wiki/Twentieth_Amendment_to_the_United_States_Constitution"
                            sections:[NSArray arrayWithObjects:
                                      [Section sectionWithText:NSLocalizedString(@"The terms of the President and Vice President shall end at noon on the 20th day of January, and the terms of Senators and Representatives at noon on the 3d day of January, of the years in which such terms would have ended if this article had not been ratified; and the terms of their successors shall then begin.", nil)],
                                      [Section sectionWithText:NSLocalizedString(@"The Congress shall assemble at least once in every year, and such meeting shall begin at noon on the 3d day of January, unless they shall by law appoint a different day.", nil)],
                                      [Section sectionWithText:NSLocalizedString(@"If, at the time fixed for the beginning of the term of the President, the President elect shall have died, the Vice President elect shall become President. If a President shall not have been chosen before the time fixed for the beginning of his term, or if the President elect shall have failed to qualify, then the Vice President elect shall act as President until a President shall have qualified; and the Congress may by law provide for the case wherein neither a President elect nor a Vice President elect shall have qualified, declaring who shall then act as President, or the manner in which one who is to act shall be selected, and such person shall act accordingly until a President or Vice President shall have qualified.", nil)],
                                      [Section sectionWithText:NSLocalizedString(@"The Congress may by law provide for the case of the death of any of the persons from whom the House of Representatives may choose a President whenever the right of choice shall have devolved upon them, and for the case of the death of any of the persons from whom the Senate may choose a Vice President whenever the right of choice shall have devolved upon them.", nil)],
                                      [Section sectionWithText:NSLocalizedString(@"Sections 1 and 2 shall take effect on the 15th day of October following the ratification of this article.", nil)],
                                      [Section sectionWithText:NSLocalizedString(@"This article shall be inoperative unless it shall have been ratified as an amendment to the Constitution by the legislatures of three-fourths of the several states within seven years from the date of its submission.", nil)], nil]];
    Amendment* amendment21 =
    [Amendment amendmentWithSynopsis:NSLocalizedString(@"Repeal of Prohibition", nil)
                                year:1933
                                link:@"http://en.wikipedia.org/wiki/Twenty-first_Amendment_to_the_United_States_Constitution"
                            sections:[NSArray arrayWithObjects:
                                      [Section sectionWithText:NSLocalizedString(@"The eighteenth article of amendment to the Constitution of the United States is hereby repealed.", nil)],
                                      [Section sectionWithText:NSLocalizedString(@"The transportation or importation into any state, territory, or possession of the United States for delivery or use therein of intoxicating liquors, in violation of the laws thereof, is hereby prohibited.", nil)],
                                      [Section sectionWithText:NSLocalizedString(@"This article shall be inoperative unless it shall have been ratified as an amendment to the Constitution by conventions in the several states, as provided in the Constitution, within seven years from the date of the submission hereof to the states by the Congress.", nil)], nil]];
    Amendment* amendment22 =
    [Amendment amendmentWithSynopsis:NSLocalizedString(@"Presidential Term Limit", nil)
                                year:1951
                                link:@"http://en.wikipedia.org/wiki/Twenty-second_Amendment_to_the_United_States_Constitution"
                            sections:[NSArray arrayWithObjects:
                                      [Section sectionWithText:NSLocalizedString(@"No person shall be elected to the office of the President more than twice, and no person who has held the office of President, or acted as President, for more than two years of a term to which some other person was elected President shall be elected to the office of the President more than once. But this article shall not apply to any person holding the office of President when this article was proposed by the Congress, and shall not prevent any person who may be holding the office of President, or acting as President, during the term within which this article becomes operative from holding the office of President or acting as President during the remainder of such term.", nil)],
                                      [Section sectionWithText:NSLocalizedString(@"This article shall be inoperative unless it shall have been ratified as an amendment to the Constitution by the legislatures of three-fourths of the several states within seven years from the date of its submission to the states by the Congress.", nil)], nil]];
    Amendment* amendment23 =
    [Amendment amendmentWithSynopsis:NSLocalizedString(@"D.C. Vote", nil)
                                year:1961
                                link:@"http://en.wikipedia.org/wiki/Twenty-third_Amendment_to_the_United_States_Constitution"
                            sections:[NSArray arrayWithObjects:
                                      [Section sectionWithText:NSLocalizedString(@"The District constituting the seat of government of the United States shall appoint in such manner as the Congress may direct:\n\n"
                                                                                 @"A number of electors of President and Vice President equal to the whole number of Senators and Representatives in Congress to which the District would be entitled if it were a state, but in no event more than the least populous state; they shall be in addition to those appointed by the states, but they shall be considered, for the purposes of the election of President and Vice President, to be electors appointed by a state; and they shall meet in the District and perform such duties as provided by the twelfth article of amendment.", nil)],
                                      [Section sectionWithText:NSLocalizedString(@"The Congress shall have power to enforce this article by appropriate legislation.", nil)], nil]];
    
    Amendment* amendment24 =
    [Amendment amendmentWithSynopsis:NSLocalizedString(@"Poll Tax", nil)
                                year:1964
                                link:@"http://en.wikipedia.org/wiki/Twenty-fourth_Amendment_to_the_United_States_Constitution"
                            sections:[NSArray arrayWithObjects:
                                      [Section sectionWithText:NSLocalizedString(@"The right of citizens of the United States to vote in any primary or other election for President or Vice President, for electors for President or Vice President, or for Senator or Representative in Congress, shall not be denied or abridged by the United States or any state by reason of failure to pay any poll tax or other tax.", nil)],
                                      [Section sectionWithText:NSLocalizedString(@"The Congress shall have power to enforce this article by appropriate legislation.", nil)], nil]];
    Amendment* amendment25 =
    [Amendment amendmentWithSynopsis:NSLocalizedString(@"Presidential Succession", nil)
                                year:1967
                                link:@"http://en.wikipedia.org/wiki/Twenty-fifth_Amendment_to_the_United_States_Constitution"
                            sections:[NSArray arrayWithObjects:
                                      [Section sectionWithText:NSLocalizedString(@"In case of the removal of the President from office or of his death or resignation, the Vice President shall become President.", nil)],
                                      [Section sectionWithText:NSLocalizedString(@"Whenever there is a vacancy in the office of the Vice President, the President shall nominate a Vice President who shall take office upon confirmation by a majority vote of both Houses of Congress.", nil)],
                                      [Section sectionWithText:NSLocalizedString(@"Whenever the President transmits to the President pro tempore of the Senate and the Speaker of the House of Representatives his written declaration that he is unable to discharge the powers and duties of his office, and until he transmits to them a written declaration to the contrary, such powers and duties shall be discharged by the Vice President as Acting President.", nil)],
                                      [Section sectionWithText:NSLocalizedString(@"Whenever the Vice President and a majority of either the principal officers of the executive departments or of such other body as Congress may by law provide, transmit to the President pro tempore of the Senate and the Speaker of the House of Representatives their written declaration that the President is unable to discharge the powers and duties of his office, the Vice President shall immediately assume the powers and duties of the office as Acting President.\n\n"
                                                                                 @"Thereafter, when the President transmits to the President pro tempore of the Senate and the Speaker of the House of Representatives his written declaration that no inability exists, he shall resume the powers and duties of his office unless the Vice President and a majority of either the principal officers of the executive department or of such other body as Congress may by law provide, transmit within four days to the President pro tempore of the Senate and the Speaker of the House of Representatives their written declaration that the President is unable to discharge the powers and duties of his office. Thereupon Congress shall decide the issue, assembling within forty-eight hours for that purpose if not in session. If the Congress, within twenty-one days after receipt of the latter written declaration, or, if Congress is not in session, within twenty-one days after Congress is required to assemble, determines by two-thirds vote of both Houses that the President is unable to discharge the powers and duties of his office, the Vice President shall continue to discharge the same as Acting President; otherwise, the President shall resume the powers and duties of his office.", nil)], nil]];
    Amendment* amendment26 =
    [Amendment amendmentWithSynopsis:NSLocalizedString(@"Vote at Age 18", nil)
                                year:1971
                                link:@"http://en.wikipedia.org/wiki/Twenty-sixth_Amendment_to_the_United_States_Constitution"
                            sections:[NSArray arrayWithObjects:
                                      [Section sectionWithText:NSLocalizedString(@"The right of citizens of the United States, who are 18 years of age or older, to vote, shall not be denied or abridged by the United States or any state on account of age.", nil)],
                                      [Section sectionWithText:NSLocalizedString(@"The Congress shall have the power to enforce this article by appropriate legislation.", nil)], nil]];
    Amendment* amendment27 =
    [Amendment amendmentWithSynopsis:NSLocalizedString(@"Congressional Compensation", nil)
                                year:1992
                                link:@"http://en.wikipedia.org/wiki/Twenty-seventh_Amendment_to_the_United_States_Constitution"
                                text:NSLocalizedString(@"No law, varying the compensation for the services of the Senators and Representatives, shall take effect, until an election of Representatives shall have intervened.", nil)];
    
    NSArray* articles = [NSArray arrayWithObjects:article1, article2, article3, article4, article5, article6, article7, nil];
    
    NSArray* amendments =
    [NSArray arrayWithObjects:amendment1, amendment2, amendment3, amendment4, amendment5,
     amendment6, amendment7, amendment8, amendment9, amendment10,
     amendment11, amendment12, amendment13, amendment14, amendment15,
     amendment16, amendment17, amendment18, amendment19, amendment20,
     amendment21, amendment22, amendment23, amendment24, amendment25,
     amendment26, amendment27, nil];
    
    MultiDictionary* signers = [MultiDictionary dictionary];
    [signers addObjects:[NSArray arrayWithObjects:
                         person(@"George Washington", @"http://en.wikipedia.org/wiki/George_Washington"),
                         person(@"John Blair", @"http://en.wikipedia.org/wiki/John_Blair"),
                         person(@"James Madison Jr.", @"http://en.wikipedia.org/wiki/James_Madison"), nil] forKey:@"Virginia"];
    [signers addObjects:[NSArray arrayWithObjects:
                         person(@"John Langdon", @"http://en.wikipedia.org/wiki/John_Langdon"),
                         person(@"Nicholas Gilman", @"http://en.wikipedia.org/wiki/Nicholas_Gilman"), nil] forKey:@"New Hampshire"];
    [signers addObjects:[NSArray arrayWithObjects:
                         person(@"Nathaniel Gorham", @"http://en.wikipedia.org/wiki/Nathaniel_Gorham"),
                         person(@"Rufus King", @"http://en.wikipedia.org/wiki/Rufus_King"), nil] forKey:@"Massachusetts"];
    [signers addObjects:[NSArray arrayWithObjects:
                         person(@"William Samuel Johnson", @"http://en.wikipedia.org/wiki/William_Samuel_Johnson"), 
                         person(@"Roger Sherman", @"http://en.wikipedia.org/wiki/Roger_Sherman"), nil] forKey:@"Connecticut"];
    [signers addObject:person(@"Alexander Hamilton", @"http://en.wikipedia.org/wiki/Alexander_Hamilton") forKey:@"New York"];
    [signers addObjects:[NSArray arrayWithObjects:
                         person(@"William Livingston", @"http://en.wikipedia.org/wiki/William_Livingston"),
                         person(@"David Brearly", @"http://en.wikipedia.org/wiki/David_Brearly"),
                         person(@"William Paterson", @"http://en.wikipedia.org/wiki/William_Paterson_(judge)"),
                         person(@"Jonathan Dayton", @"http://en.wikipedia.org/wiki/Jonathan_Dayton"), nil] forKey:@"New Jersey"];
    [signers addObjects:[NSArray arrayWithObjects:
                         person(@"Benjamin Franklin", @"http://en.wikipedia.org/wiki/Benjamin_franklin"),
                         person(@"Thomas Mifflin", @"http://en.wikipedia.org/wiki/Thomas_Mifflin"), 
                         person(@"Robert Morris", @"http://en.wikipedia.org/wiki/Robert_Morris_(financier)"),
                         person(@"George Clymer", @"http://en.wikipedia.org/wiki/George_Clymer"),
                         person(@"Thomas FitzSimons", @"http://en.wikipedia.org/wiki/Thomas_Fitzsimons"),
                         person(@"Jared Ingersoll", @"http://en.wikipedia.org/wiki/Jared_Ingersoll"),
                         person(@"James Wilson", @"http://en.wikipedia.org/wiki/James_Wilson"),
                         person(@"Gouverneur Morris", @"http://en.wikipedia.org/wiki/Gouverneur_Morris"), nil] forKey:@"Pennsylvania"];
    [signers addObjects:[NSArray arrayWithObjects:
                         person(@"George Read", @"http://en.wikipedia.org/wiki/George_Read_(signer)"),
                         person(@"Gunning Bedford Jr.", @"http://en.wikipedia.org/wiki/Gunning_Bedford,_Jr."),
                         person(@"John Dickinson", @"http://en.wikipedia.org/wiki/John_Dickinson_(delegate)"),
                         person(@"Richard Bassett", @"http://en.wikipedia.org/wiki/Richard_Bassett"),
                         person(@"Jacob Broom", @"http://en.wikipedia.org/wiki/Jacob_Broom"), nil] forKey:@"Delaware"];
    [signers addObjects:[NSArray arrayWithObjects:
                         person(@"James McHenry", @"http://en.wikipedia.org/wiki/James_McHenry"),
                         person(@"Daniel of St. Thomas Jenifer", @"http://en.wikipedia.org/wiki/Daniel_of_St._Thomas_Jenifer"),
                         person(@"Daniel Carroll", @"http://en.wikipedia.org/wiki/Daniel_Carroll"), nil] forKey:@"Maryland"];
    [signers addObjects:[NSArray arrayWithObjects:
                         person(@"William Blount", @"http://en.wikipedia.org/wiki/William_Blount"),
                         person(@"Richard Dobbs Spaight", @"http://en.wikipedia.org/wiki/Richard_Dobbs_Spaight"),
                         person(@"Hugh Williamson", @"http://en.wikipedia.org/wiki/Hugh_Williamson"), nil] forKey:@"North Carolina"];
    [signers addObjects:[NSArray arrayWithObjects:
                         person(@"John Rutledge", @"http://en.wikipedia.org/wiki/John_Rutledge"),
                         person(@"Charles Cotesworth Pinckney", @"http://en.wikipedia.org/wiki/Charles_Cotesworth_Pinckney"),
                         person(@"Charles Pinckney", @"http://en.wikipedia.org/wiki/Charles_Pinckney_(governor)"),
                         person(@"Pierce Butler", @"http://en.wikipedia.org/wiki/Pierce_Butler"), nil] forKey:@"South Carolina"];
    [signers addObjects:[NSArray arrayWithObjects:
                         person(@"William Few", @"http://en.wikipedia.org/wiki/William_Few"),
                         person(@"Abraham Baldwin", @"http://en.wikipedia.org/wiki/Abraham_Baldwin"), nil] forKey:@"Georgia"];
    
    return [Constitution constitutionWithCountry:country
                                        preamble:NSLocalizedString(@"We the people of the United States, in order to form a more perfect union, establish justice, insure domestic tranquility, provide for the common defense, promote the general welfare, and secure the blessings of liberty to ourselves and our posterity, do ordain and establish this Constitution for the United States of America.", nil)
                                        articles:articles
                                      amendments:amendments
                                      conclusion:@""
                                         signers:signers];
}


+ (void) setupConstitutions {
    unitedStatesConstitution = [[self setupUnitedStatesConstitution] retain];
}


+ (void) setupDeclarationOfIndependence {
    NSString* text =
    @"When in the Course of human events it becomes necessary for one people to dissolve the political bands which have connected them with another and to assume among the powers of the earth, the separate and equal station to which the Laws of Nature and of Nature's God entitle them, a decent respect to the opinions of mankind requires that they should declare the causes which impel them to the separation.\n\n"
    @"We hold these truths to be self-evident, that all men are created equal, that they are endowed by their Creator with certain unalienable Rights, that among these are Life, Liberty and the pursuit of Happiness. — That to secure these rights, Governments are instituted among Men, deriving their just powers from the consent of the governed, — That whenever any Form of Government becomes destructive of these ends, it is the Right of the People to alter or to abolish it, and to institute new Government, laying its foundation on such principles and organizing its powers in such form, as to them shall seem most likely to effect their Safety and Happiness. Prudence, indeed, will dictate that Governments long established should not be changed for light and transient causes; and accordingly all experience hath shewn that mankind are more disposed to suffer, while evils are sufferable than to right themselves by abolishing the forms to which they are accustomed. But when a long train of abuses and usurpations, pursuing invariably the same Object evinces a design to reduce them under absolute Despotism, it is their right, it is their duty, to throw off such Government, and to provide new Guards for their future security. — Such has been the patient sufferance of these Colonies; and such is now the necessity which constrains them to alter their former Systems of Government. The history of the present King of Great Britain is a history of repeated injuries and usurpations, all having in direct object the establishment of an absolute Tyranny over these States. To prove this, let Facts be submitted to a candid world.\n\n"
    @"He has refused his Assent to Laws, the most wholesome and necessary for the public good.\n\n"
    @"He has forbidden his Governors to pass Laws of immediate and pressing importance, unless suspended in their operation till his Assent should be obtained; and when so suspended, he has utterly neglected to attend to them.\n\n"
    @"He has refused to pass other Laws for the accommodation of large districts of people, unless those people would relinquish the right of Representation in the Legislature, a right inestimable to them and formidable to tyrants only.\n\n"
    @"He has called together legislative bodies at places unusual, uncomfortable, and distant from the depository of their Public Records, for the sole purpose of fatiguing them into compliance with his measures.\n\n"
    @"He has dissolved Representative Houses repeatedly, for opposing with manly firmness his invasions on the rights of the people.\n\n"
    @"He has refused for a long time, after such dissolutions, to cause others to be elected, whereby the Legislative Powers, incapable of Annihilation, have returned to the People at large for their exercise; the State remaining in the mean time exposed to all the dangers of invasion from without, and convulsions within.\n\n"
    @"He has endeavoured to prevent the population of these States; for that purpose obstructing the Laws for Naturalization of Foreigners; refusing to pass others to encourage their migrations hither, and raising the conditions of new Appropriations of Lands.\n\n"
    @"He has obstructed the Administration of Justice by refusing his Assent to Laws for establishing Judiciary Powers.\n\n"
    @"He has made Judges dependent on his Will alone for the tenure of their offices, and the amount and payment of their salaries.\n\n"
    @"He has erected a multitude of New Offices, and sent hither swarms of Officers to harass our people and eat out their substance.\n\n"
    @"He has kept among us, in times of peace, Standing Armies without the Consent of our legislatures.\n\n"
    @"He has affected to render the Military independent of and superior to the Civil Power.\n\n"
    @"He has combined with others to subject us to a jurisdiction foreign to our constitution, and unacknowledged by our laws; giving his Assent to their Acts of pretended Legislation:\n\n"
    @"For quartering large bodies of armed troops among us:\n\n"
    @"For protecting them, by a mock Trial from punishment for any Murders which they should commit on the Inhabitants of these States:\n\n"
    @"For cutting off our Trade with all parts of the world:\n\n"
    @"For imposing Taxes on us without our Consent:\n\n"
    @"For depriving us in many cases, of the benefit of Trial by Jury:\n\n"
    @"For transporting us beyond Seas to be tried for pretended offences:\n\n"
    @"For abolishing the free System of English Laws in a neighbouring Province, establishing therein an Arbitrary government, and enlarging its Boundaries so as to render it at once an example and fit instrument for introducing the same absolute rule into these Colonies\n\n"
    @"For taking away our Charters, abolishing our most valuable Laws and altering fundamentally the Forms of our Governments:\n\n"
    @"For suspending our own Legislatures, and declaring themselves invested with power to legislate for us in all cases whatsoever.\n\n"
    @"He has abdicated Government here, by declaring us out of his Protection and waging War against us.\n\n"
    @"He has plundered our seas, ravaged our coasts, burnt our towns, and destroyed the lives of our people.\n\n"
    @"He is at this time transporting large Armies of foreign Mercenaries to compleat the works of death, desolation, and tyranny, already begun with circumstances of Cruelty & Perfidy scarcely paralleled in the most barbarous ages, and totally unworthy the Head of a civilized nation.\n\n"
    @"He has constrained our fellow Citizens taken Captive on the high Seas to bear Arms against their Country, to become the executioners of their friends and Brethren, or to fall themselves by their Hands.\n\n"
    @"He has excited domestic insurrections amongst us, and has endeavoured to bring on the inhabitants of our frontiers, the merciless Indian Savages whose known rule of warfare, is an undistinguished destruction of all ages, sexes and conditions.\n\n"
    @"In every stage of these Oppressions We have Petitioned for Redress in the most humble terms: Our repeated Petitions have been answered only by repeated injury. A Prince, whose character is thus marked by every act which may define a Tyrant, is unfit to be the ruler of a free people.\n\n"
    @"Nor have We been wanting in attentions to our British brethren. We have warned them from time to time of attempts by their legislature to extend an unwarrantable jurisdiction over us. We have reminded them of the circumstances of our emigration and settlement here. We have appealed to their native justice and magnanimity, and we have conjured them by the ties of our common kindred to disavow these usurpations, which would inevitably interrupt our connections and correspondence. They too have been deaf to the voice of justice and of consanguinity. We must, therefore, acquiesce in the necessity, which denounces our Separation, and hold them, as we hold the rest of mankind, Enemies in War, in Peace Friends.\n\n"
    @"We, therefore, the Representatives of the united States of America, in General Congress, Assembled, appealing to the Supreme Judge of the world for the rectitude of our intentions, do, in the Name, and by Authority of the good People of these Colonies, solemnly publish and declare, That these united Colonies are, and of Right ought to be Free and Independent States, that they are Absolved from all Allegiance to the British Crown, and that all political connection between them and the State of Great Britain, is and ought to be totally dissolved; and that as Free and Independent States, they have full Power to levy War, conclude Peace, contract Alliances, establish Commerce, and to do all other Acts and Things which Independent States may of right do. — And for the support of this Declaration, with a firm reliance on the protection of Divine Providence, we mutually pledge to each other our Lives, our Fortunes, and our sacred Honor.\n\n"
    @"— John Hancock";
    
    MultiDictionary* signers = [MultiDictionary dictionary];
    
    [signers addObjects:[NSArray arrayWithObjects:
                         person(@"Josiah Bartlett", @"http://en.wikipedia.org/wiki/Josiah_Bartlett"),
                         person(@"William Whipple", @"http://en.wikipedia.org/wiki/William_Whipple"),
                         person(@"Matthew Thornton", @"http://en.wikipedia.org/wiki/Matthew_Thornton"), nil] forKey:@"New Hampshire"];
    
    [signers addObjects:[NSArray arrayWithObjects:
                         person(@"John Hancock", @"http://en.wikipedia.org/wiki/John_Hancock"),
                         person(@"Samuel Adams", @"http://en.wikipedia.org/wiki/Samuel_adams"),
                         person(@"John Adams", @"http://en.wikipedia.org/wiki/John_Adams"),
                         person(@"Robert Treat Paine", @"http://en.wikipedia.org/wiki/Robert_Treat_Paine"),
                         person(@"Elbridge Gerry", @"http://en.wikipedia.org/wiki/Elbridge_Gerry"), nil] forKey:@"Massachusetts"];
    
    [signers addObjects:[NSArray arrayWithObjects:
                         person(@"Stephen Hopkins", @"http://en.wikipedia.org/wiki/Stephen_Hopkins_(politician)"),
                         person(@"William Ellery", @"http://en.wikipedia.org/wiki/William_Ellery"), nil] forKey:@"Rhode Island"];
    
    [signers addObjects:[NSArray arrayWithObjects:
                         person(@"Roger Sherman", @"http://en.wikipedia.org/wiki/Roger_Sherman"),
                         person(@"Samuel Huntington", @"http://en.wikipedia.org/wiki/Samuel_Huntington_(statesman)"),
                         person(@"William Williams", @"http://en.wikipedia.org/wiki/William_Williams_(signer)"),
                         person(@"Oliver Wolcott", @"http://en.wikipedia.org/wiki/Oliver_Wolcott"), nil] forKey:@"Connecticut"];
    
    [signers addObjects:[NSArray arrayWithObjects:
                         person(@"William Floyd", @"http://en.wikipedia.org/wiki/William_Floyd"),
                         person(@"Philip Livingston", @"http://en.wikipedia.org/wiki/Philip_Livingston"),
                         person(@"Francis Lewis", @"http://en.wikipedia.org/wiki/Francis_Lewis"),
                         person(@"Lewis Morris", @"http://en.wikipedia.org/wiki/Lewis_Morris"), nil] forKey:@"New York"];
    
    [signers addObjects:[NSArray arrayWithObjects:
                         person(@"Richard Stockton", @"http://en.wikipedia.org/wiki/Richard_Stockton_(1730-1781)"),
                         person(@"John Witherspoon", @"http://en.wikipedia.org/wiki/John_Witherspoon"),
                         person(@"Francis Hopkinson", @"http://en.wikipedia.org/wiki/Francis_Hopkinson"),
                         person(@"John Hart", @"http://en.wikipedia.org/wiki/John_Hart"),
                         person(@"Abraham Clark", @"http://en.wikipedia.org/wiki/Abraham_Clark"), nil] forKey:@"New Jersey"];
    
    [signers addObjects:[NSArray arrayWithObjects:
                         person(@"Robert Morris", @"http://en.wikipedia.org/wiki/Robert_Morris_(financier)"),
                         person(@"Benjamin Rush", @"http://en.wikipedia.org/wiki/Benjamin_Rush"),
                         person(@"Benjamin Franklin", @"http://en.wikipedia.org/wiki/Benjamin_Franklin"),
                         person(@"John Morton", @"http://en.wikipedia.org/wiki/John_Morton_(politician)"),
                         person(@"George Clymer", @"http://en.wikipedia.org/wiki/George_Clymer"),
                         person(@"James Smith", @"http://en.wikipedia.org/wiki/James_Smith_(political_figure)"),
                         person(@"George Taylor", @"http://en.wikipedia.org/wiki/George_Taylor_(delegate)"),
                         person(@"James Wilson", @"http://en.wikipedia.org/wiki/James_Wilson"),
                         person(@"George Ross", @"http://en.wikipedia.org/wiki/George_Ross_(delegate)"), nil] forKey:@"Pennsylvania"];
    
    [signers addObjects:[NSArray arrayWithObjects:
                         person(@"Caesar Rodney", @"http://en.wikipedia.org/wiki/Caesar_Rodney"),
                         person(@"George Read", @"http://en.wikipedia.org/wiki/George_Read_(signer)"),
                         person(@"Thomas McKean", @"http://en.wikipedia.org/wiki/Thomas_McKean"), nil] forKey:@"Delaware"];
    
    [signers addObjects:[NSArray arrayWithObjects:
                         person(@"Samuel Chase", @"http://en.wikipedia.org/wiki/Samuel_Chase"),
                         person(@"William Paca", @"http://en.wikipedia.org/wiki/William_Paca"),
                         person(@"Thomas Stone", @"http://en.wikipedia.org/wiki/Thomas_Stone"),
                         person(@"Charles Carroll of Carrollton", @"http://en.wikipedia.org/wiki/Charles_Carroll_of_Carrollton"), nil] forKey:@"Maryland"];
    
    [signers addObjects:[NSArray arrayWithObjects:
                         person(@"George Wythe", @"http://en.wikipedia.org/wiki/George_Wythe"),
                         person(@"Richard Henry Lee", @"http://en.wikipedia.org/wiki/Richard_Henry_Lee"),
                         person(@"Thomas Jefferson", @"http://en.wikipedia.org/wiki/Thomas_Jefferson"),
                         person(@"Benjamin Harrison", @"http://en.wikipedia.org/wiki/Benjamin_Harrison"),
                         person(@"Thomas Nelson Jr.", @"http://en.wikipedia.org/wiki/Thomas_Nelson,_Jr."),
                         person(@"Francis Lightfoot Lee", @"http://en.wikipedia.org/wiki/Francis_Lightfoot_Lee"),
                         person(@"Carter Braxton", @"http://en.wikipedia.org/wiki/Carter_Braxton"), nil] forKey:@"Virginia"];
    
    [signers addObjects:[NSArray arrayWithObjects:
                         person(@"William Hooper", @"http://en.wikipedia.org/wiki/William_Hooper"),
                         person(@"Joseph Hewes", @"http://en.wikipedia.org/wiki/Joseph_Hewes"),
                         person(@"John Penn", @"http://en.wikipedia.org/wiki/John_Penn_(delegate)"), nil] forKey:@"North Carolina"];
    
    [signers addObjects:[NSArray arrayWithObjects:
                         person(@"Edward Rutledge", @"http://en.wikipedia.org/wiki/Edward_Rutledge"),
                         person(@"Thomas Heyward Jr.", @"http://en.wikipedia.org/wiki/Thomas_Heyward"),
                         person(@"Thomas Lynch Jr.", @"http://en.wikipedia.org/wiki/Thomas_Lynch,_Jr."),
                         person(@"Arthur Middleton", @"http://en.wikipedia.org/wiki/Arthur_Middleton"), nil] forKey:@"South Carolina"];
    
    [signers addObjects:[NSArray arrayWithObjects:
                         person(@"Button Gwinnett", @"http://en.wikipedia.org/wiki/Button_Gwinnett"),
                         person(@"Lyman Hall", @"http://en.wikipedia.org/wiki/Lyman_Hall"),
                         person(@"George Walton", @"http://en.wikipedia.org/wiki/George_Walton"), nil] forKey:@"Georgia"];
    
    NSDate* date = [NSDate dateWithNaturalLanguageString:@"July 4, 1776"];
    
    declarationOfIndependence = [[DeclarationOfIndependence declarationWithText:text signers:signers date:date] retain];
}


+ (void) setupArticlesOfConfederation {
    NSString* country = [[NSLocale currentLocale] displayNameForKey:NSLocaleCountryCode value:@"US"];    
    
    NSString* preamble =
    NSLocalizedString(@"To all to whom these Presents shall come, we the undersigned Delegates of the States affixed to our Names send greeting.\n\n"
                      @"Articles of Confederation and perpetual Union between the States of New Hampshire, Massachusetts bay, Rhode Island and Providence Plantations, Connecticut, New York, New Jersey, Pennsylvania, Delaware, Maryland, Virginia, North Carolina, South Carolina and Georgia.", nil);
    
    NSArray* articles = 
    [NSArray arrayWithObjects:
     [Article articleWithTitle:@"Article I"
                       section:[Section sectionWithText:NSLocalizedString(@"The Stile of this Confederacy shall be 'The United States of America.'", nil)]],
     [Article articleWithTitle:@"Article II"
                       section:[Section sectionWithText:NSLocalizedString(@"Each state retains its sovereignty, freedom, and independence, and every power, jurisdiction, and right, which is not by this Confederation expressly delegated to the United States, in Congress assembled.", nil)]],
     [Article articleWithTitle:@"Article III"
                       section:[Section sectionWithText:NSLocalizedString(@"The said States hereby severally enter into a firm league of friendship with each other, for their common defense, the security of their liberties, and their mutual and general welfare, binding themselves to assist each other, against all force offered to, or attacks made upon them, or any of them, on account of religion, sovereignty, trade, or any other pretense whatever.", nil)]],
     [Article articleWithTitle:@"Article IV"
                       section:[Section sectionWithText:NSLocalizedString(@"The better to secure and perpetuate mutual friendship and intercourse among the people of the different States in this Union, the free inhabitants of each of these States, paupers, vagabonds, and fugitives from justice excepted, shall be entitled to all privileges and immunities of free citizens in the several States; and the people of each State shall free ingress and regress to and from any other State, and shall enjoy therein all the privileges of trade and commerce, subject to the same duties, impositions, and restrictions as the inhabitants thereof respectively, provided that such restrictions shall not extend so far as to prevent the removal of property imported into any State, to any other State, of which the owner is an inhabitant; provided also that no imposition, duties or restriction shall be laid by any State, on the property of the United States, or either of them.\n\n"
                                                                          @"If any person guilty of, or charged with, treason, felony, or other high misdemeanor in any State, shall flee from justice, and be found in any of the United States, he shall, upon demand of the Governor or executive power of the State from which he fled, be delivered up and removed to the State having jurisdiction of his offense.\n\n"
                                                                          @"Full faith and credit shall be given in each of these States to the records, acts, and judicial proceedings of the courts and magistrates of every other State.", nil)]],
     [Article articleWithTitle:@"Article V"
                       section:[Section sectionWithText:NSLocalizedString(@"For the most convenient management of the general interests of the United States, delegates shall be annually appointed in such manner as the legislatures of each State shall direct, to meet in Congress on the first Monday in November, in every year, with a power reserved to each State to recall its delegates, or any of them, at any time within the year, and to send others in their stead for the remainder of the year.\n\n"
                                                                          @"No State shall be represented in Congress by less than two, nor more than seven members; and no person shall be capable of being a delegate for more than three years in any term of six years; nor shall any person, being a delegate, be capable of holding any office under the United States, for which he, or another for his benefit, receives any salary, fees or emolument of any kind.\n\n"
                                                                          @"Each State shall maintain its own delegates in a meeting of the States, and while they act as members of the committee of the States.\n\n"
                                                                          @"In determining questions in the United States in Congress assembled, each State shall have one vote.\n\n"
                                                                          @"Freedom of speech and debate in Congress shall not be impeached or questioned in any court or place out of Congress, and the members of Congress shall be protected in their persons from arrests or imprisonments, during the time of their going to and from, and attendance on Congress, except for treason, felony, or breach of the peace.", nil)]],
     [Article articleWithTitle:@"Article VI"
                       section:[Section sectionWithText:NSLocalizedString(@"No State, without the consent of the United States in Congress assembled, shall send any embassy to, or receive any embassy from, or enter into any conference, agreement, alliance or treaty with any King, Prince or State; nor shall any person holding any office of profit or trust under the United States, or any of them, accept any present, emolument, office or title of any kind whatever from any King, Prince or foreign State; nor shall the United States in Congress assembled, or any of them, grant any title of nobility.\n\n"
                                                                          @"No two or more States shall enter into any treaty, confederation or alliance whatever between them, without the consent of the United States in Congress assembled, specifying accurately the purposes for which the same is to be entered into, and how long it shall continue.\n\n"
                                                                          @"No State shall lay any imposts or duties, which may interfere with any stipulations in treaties, entered into by the United States in Congress assembled, with any King, Prince or State, in pursuance of any treaties already proposed by Congress, to the courts of France and Spain.\n\n"
                                                                          @"No vessel of war shall be kept up in time of peace by any State, except such number only, as shall be deemed necessary by the United States in Congress assembled, for the defense of such State, or its trade; nor shall any body of forces be kept up by any State in time of peace, except such number only, as in the judgement of the United States in Congress assembled, shall be deemed requisite to garrison the forts necessary for the defense of such State; but every State shall always keep up a well-regulated and disciplined militia, sufficiently armed and accoutered, and shall provide and constantly have ready for use, in public stores, a due number of filed pieces and tents, and a proper quantity of arms, ammunition and camp equipage.\n\n"
                                                                          @"No State shall engage in any war without the consent of the United States in Congress assembled, unless such State be actually invaded by enemies, or shall have received certain advice of a resolution being formed by some nation of Indians to invade such State, and the danger is so imminent as not to admit of a delay till the United States in Congress assembled can be consulted; nor shall any State grant commissions to any ships or vessels of war, nor letters of marque or reprisal, except it be after a declaration of war by the United States in Congress assembled, and then only against the Kingdom or State and the subjects thereof, against which war has been so declared, and under such regulations as shall be established by the United States in Congress assembled, unless such State be infested by pirates, in which case vessels of war may be fitted out for that occasion, and kept so long as the danger shall continue, or until the United States in Congress assembled shall determine otherwise.", nil)]],
     [Article articleWithTitle:@"Article VII"
                       section:[Section sectionWithText:NSLocalizedString(@"When land forces are raised by any State for the common defense, all officers of or under the rank of colonel, shall be appointed by the legislature of each State respectively, by whom such forces shall be raised, or in such manner as such State shall direct, and all vacancies shall be filled up by the State which first made the appointment.", nil)]],
     
     [Article articleWithTitle:@"Article VIII"
                       section:[Section sectionWithText:NSLocalizedString(@"All charges of war, and all other expenses that shall be incurred for the common defense or general welfare, and allowed by the United States in Congress assembled, shall be defrayed out of a common treasury, which shall be supplied by the several States in proportion to the value of all land within each State, granted or surveyed for any person, as such land and the buildings and improvements thereon shall be estimated according to such mode as the United States in Congress assembled, shall from time to time direct and appoint.\n\n"
                                                                          @"The taxes for paying that proportion shall be laid and levied by the authority and direction of the legislatures of the several States within the time agreed upon by the United States in Congress assembled.", nil)]],
     [Article articleWithTitle:@"Article IX"
                       section:[Section sectionWithText:NSLocalizedString(@"The United States in Congress assembled, shall have the sole and exclusive right and power of determining on peace and war, except in the cases mentioned in the sixth article — of sending and receiving ambassadors — entering into treaties and alliances, provided that no treaty of commerce shall be made whereby the legislative power of the respective States shall be restrained from imposing such imposts and duties on foreigners, as their own people are subjected to, or from prohibiting the exportation or importation of any species of goods or commodities whatsoever — of establishing rules for deciding in all cases, what captures on land or water shall be legal, and in what manner prizes taken by land or naval forces in the service of the United States shall be divided or appropriated — of granting letters of marque and reprisal in times of peace — appointing courts for the trial of piracies and felonies committed on the high seas and establishing courts for receiving and determining finally appeals in all cases of captures, provided that no member of Congress shall be appointed a judge of any of the said courts.\n\n"
                                                                          @"The United States in Congress assembled shall also be the last resort on appeal in all disputes and differences now subsisting or that hereafter may arise between two or more States concerning boundary, jurisdiction or any other causes whatever; which authority shall always be exercised in the manner following. Whenever the legislative or executive authority or lawful agent of any State in controversy with another shall present a petition to Congress stating the matter in question and praying for a hearing, notice thereof shall be given by order of Congress to the legislative or executive authority of the other State in controversy, and a day assigned for the appearance of the parties by their lawful agents, who shall then be directed to appoint by joint consent, commissioners or judges to constitute a court for hearing and determining the matter in question: but if they cannot agree, Congress shall name three persons out of each of the United States, and from the list of such persons each party shall alternately strike out one, the petitioners beginning, until the number shall be reduced to thirteen; and from that number not less than seven, nor more than nine names as Congress shall direct, shall in the presence of Congress be drawn out by lot, and the persons whose names shall be so drawn or any five of them, shall be commissioners or judges, to hear and finally determine the controversy, so always as a major part of the judges who shall hear the cause shall agree in the determination: and if either party shall neglect to attend at the day appointed, without showing reasons, which Congress shall judge sufficient, or being present shall refuse to strike, the Congress shall proceed to nominate three persons out of each State, and the secretary of Congress shall strike in behalf of such party absent or refusing; and the judgement and sentence of the court to be appointed, in the manner before prescribed, shall be final and conclusive; and if any of the parties shall refuse to submit to the authority of such court, or to appear or defend their claim or cause, the court shall nevertheless proceed to pronounce sentence, or judgement, which shall in like manner be final and decisive, the judgement or sentence and other proceedings being in either case transmitted to Congress, and lodged among the acts of Congress for the security of the parties concerned: provided that every commissioner, before he sits in judgement, shall take an oath to be administered by one of the judges of the supreme or superior court of the State, where the cause shall be tried, 'well and truly to hear and determine the matter in question, according to the best of his judgement, without favor, affection or hope of reward': provided also, that no State shall be deprived of territory for the benefit of the United States.\n\n"
                                                                          @"All controversies concerning the private right of soil claimed under different grants of two or more States, whose jurisdictions as they may respect such lands, and the States which passed such grants are adjusted, the said grants or either of them being at the same time claimed to have originated antecedent to such settlement of jurisdiction, shall on the petition of either party to the Congress of the United States, be finally determined as near as may be in the same manner as is before prescribed for deciding disputes respecting territorial jurisdiction between different States.\n\n"
                                                                          @"The United States in Congress assembled shall also have the sole and exclusive right and power of regulating the alloy and value of coin struck by their own authority, or by that of the respective States — fixing the standards of weights and measures throughout the United States — regulating the trade and managing all affairs with the Indians, not members of any of the States, provided that the legislative right of any State within its own limits be not infringed or violated — establishing or regulating post offices from one State to another, throughout all the United States, and exacting such postage on the papers passing through the same as may be requisite to defray the expenses of the said office — appointing all officers of the land forces, in the service of the United States, excepting regimental officers — appointing all the officers of the naval forces, and commissioning all officers whatever in the service of the United States — making rules for the government and regulation of the said land and naval forces, and directing their operations.\n\n"
                                                                          @"The United States in Congress assembled shall have authority to appoint a committee, to sit in the recess of Congress, to be denominated 'A Committee of the States', and to consist of one delegate from each State; and to appoint such other committees and civil officers as may be necessary for managing the general affairs of the United States under their direction — to appoint one of their members to preside, provided that no person be allowed to serve in the office of president more than one year in any term of three years; to ascertain the necessary sums of money to be raised for the service of the United States, and to appropriate and apply the same for defraying the public expenses — to borrow money, or emit bills on the credit of the United States, transmitting every half-year to the respective States an account of the sums of money so borrowed or emitted — to build and equip a navy — to agree upon the number of land forces, and to make requisitions from each State for its quota, in proportion to the number of white inhabitants in such State; which requisition shall be binding, and thereupon the legislature of each State shall appoint the regimental officers, raise the men and cloath, arm and equip them in a solid- like manner, at the expense of the United States; and the officers and men so cloathed, armed and equipped shall march to the place appointed, and within the time agreed on by the United States in Congress assembled. But if the United States in Congress assembled shall, on consideration of circumstances judge proper that any State should not raise men, or should raise a smaller number of men than the quota thereof, such extra number shall be raised, officered, cloathed, armed and equipped in the same manner as the quota of each State, unless the legislature of such State shall judge that such extra number cannot be safely spread out in the same, in which case they shall raise, officer, cloath, arm and equip as many of such extra number as they judge can be safely spared. And the officers and men so cloathed, armed, and equipped, shall march to the place appointed, and within the time agreed on by the United States in Congress assembled.\n\n"
                                                                          @"The United States in Congress assembled shall never engage in a war, nor grant letters of marque or reprisal in time of peace, nor enter into any treaties or alliances, nor coin money, nor regulate the value thereof, nor ascertain the sums and expenses necessary for the defense and welfare of the United States, or any of them, nor emit bills, nor borrow money on the credit of the United States, nor appropriate money, nor agree upon the number of vessels of war, to be built or purchased, or the number of land or sea forces to be raised, nor appoint a commander in chief of the army or navy, unless nine States assent to the same: nor shall a question on any other point, except for adjourning from day to day be determined, unless by the votes of the majority of the United States in Congress assembled.\n\n"
                                                                          @"The Congress of the United States shall have power to adjourn to any time within the year, and to any place within the United States, so that no period of adjournment be for a longer duration than the space of six months, and shall publish the journal of their proceedings monthly, except such parts thereof relating to treaties, alliances or military operations, as in their judgement require secrecy; and the yeas and nays of the delegates of each State on any question shall be entered on the journal, when it is desired by any delegates of a State, or any of them, at his or their request shall be furnished with a transcript of the said journal, except such parts as are above excepted, to lay before the legislatures of the several States.", nil)]],
     [Article articleWithTitle:@"Article X"
                       section:[Section sectionWithText:NSLocalizedString(@"The Committee of the States, or any nine of them, shall be authorized to execute, in the recess of Congress, such of the powers of Congress as the United States in Congress assembled, by the consent of the nine States, shall from time to time think expedient to vest them with; provided that no power be delegated to the said Committee, for the exercise of which, by the Articles of Confederation, the voice of nine States in the Congress of the United States assembled be requisite.", nil)]],
     [Article articleWithTitle:@"Article XI"
                       section:[Section sectionWithText:NSLocalizedString(@"Canada acceding to this confederation, and adjoining in the measures of the United States, shall be admitted into, and entitled to all the advantages of this Union; but no other colony shall be admitted into the same, unless such admission be agreed to by nine States.", nil)]],
     [Article articleWithTitle:@"Article XII"
                       section:[Section sectionWithText:NSLocalizedString(@"All bills of credit emitted, monies borrowed, and debts contracted by, or under the authority of Congress, before the assembling of the United States, in pursuance of the present confederation, shall be deemed and considered as a charge against the United States, for payment and satisfaction whereof the said United States, and the public faith are hereby solemnly pledged.", nil)]],
     [Article articleWithTitle:@"Article XIII"
                       section:[Section sectionWithText:NSLocalizedString(@"Every State shall abide by the determination of the United States in Congress assembled, on all questions which by this confederation are submitted to them. And the Articles of this Confederation shall be inviolably observed by every State, and the Union shall be perpetual; nor shall any alteration at any time hereafter be made in any of them; unless such alteration be agreed to in a Congress of the United States, and be afterwards confirmed by the legislatures of every State.", nil)]],
     
     nil];
    
    NSString* conclusion = @"And Whereas it hath pleased the Great Governor of the World to incline the hearts of the legislatures we respectively represent in Congress, to approve of, and to authorize us to ratify the said Articles of Confederation and perpetual Union. Know Ye that we the undersigned delegates, by virtue of the power and authority to us given for that purpose, do by these presents, in the name and in behalf of our respective constituents, fully and entirely ratify and confirm each and every of the said Articles of Confederation and perpetual Union, and all and singular the matters and things therein contained: And we do further solemnly plight and engage the faith of our respective constituents, that they shall abide by the determinations of the United States in Congress assembled, on all questions, which by the said Confederation are submitted to them. And that the Articles thereof shall be inviolably observed by the States we respectively represent, and that the Union shall be perpetual.";
    
    MultiDictionary* signers = [MultiDictionary dictionary];
    [signers addObjects:[NSArray arrayWithObjects:
                         person(@"Josiah Bartlett", @"http://en.wikipedia.org/wiki/Josiah_Bartlett"),
                         person(@"John Wentworth Jr.", @"http://en.wikipedia.org/wiki/John_Wentworth_Jr."),nil]
                 forKey:@"New Hampshire"];
    
    [signers addObjects:[NSArray arrayWithObjects:
                         person(@"John Hancock", @"http://en.wikipedia.org/wiki/John_Hancock"),
                         person(@"Samuel Adams", @"http://en.wikipedia.org/wiki/Samuel_Adams"),
                         person(@"Elbridge Gerry", @"http://en.wikipedia.org/wiki/Elbridge_Gerry"),
                         person(@"Francis Dana", @"http://en.wikipedia.org/wiki/Francis_Dana"),
                         person(@"James Lovell", @"http://en.wikipedia.org/wiki/James_Lovell_(delegate)"),
                         person(@"Samuel Holten", @"http://en.wikipedia.org/wiki/Samuel_Holten"),nil]
                 forKey:@"Massachusetts"];
    
    [signers addObjects:[NSArray arrayWithObjects:
                         person(@"William Ellery", @"http://en.wikipedia.org/wiki/William_Ellery"),
                         person(@"Henry Marchant", @"http://en.wikipedia.org/wiki/Henry_Marchant"),
                         person(@"John Collins", @"http://en.wikipedia.org/wiki/John_Collins_(delegate)"),nil]
                 forKey:@"Rhode Island"];
    
    [signers addObjects:[NSArray arrayWithObjects:
                         person(@"Roger Sherman", @"http://en.wikipedia.org/wiki/Roger_Sherman"),
                         person(@"Samuel Huntington", @"http://en.wikipedia.org/wiki/Samuel_Huntington_(statesman)"),
                         person(@"Oliver Wolcott", @"http://en.wikipedia.org/wiki/Oliver_Wolcott"),
                         person(@"Titus Hosmer", @"http://en.wikipedia.org/wiki/Titus_Hosmer"),
                         person(@"Andrew Adams", @"http://en.wikipedia.org/wiki/Andrew_Adams_(congressman)"),nil]
                 forKey:@"Connecticut"];
    
    [signers addObjects:[NSArray arrayWithObjects:
                         person(@"James Duane", @"http://en.wikipedia.org/wiki/James_Duane"),
                         person(@"Francis Lewis", @"http://en.wikipedia.org/wiki/Francis_Lewis"),
                         person(@"William Duer", @"http://en.wikipedia.org/wiki/William_Duer_(1747-1799)"),
                         person(@"Gouverneur Morris", @"http://en.wikipedia.org/wiki/Gouverneur_Morris"),nil]
                 forKey:@"New York"];
    
    [signers addObjects:[NSArray arrayWithObjects:
                         person(@"John Witherspoon", @"http://en.wikipedia.org/wiki/John_Witherspoon"),
                         person(@"Nathaniel Scudder", @"http://en.wikipedia.org/wiki/Nathaniel_Scudder"),nil]
                 forKey:@"New Jersey"];
    
    [signers addObjects:[NSArray arrayWithObjects:
                         person(@"Robert Morris", @"http://en.wikipedia.org/wiki/Robert_Morris_(financier)"),
                         person(@"Daniel Roberdeau", @"http://en.wikipedia.org/wiki/Daniel_Roberdeau"),
                         person(@"John Bayard Smith", @"http://en.wikipedia.org/wiki/Jonathan_Bayard_Smith"),
                         person(@"William Clingan", @"http://en.wikipedia.org/wiki/William_Clingan"),
                         person(@"Joseph Reed", @"http://en.wikipedia.org/wiki/Joseph_Reed_(jurist)"),nil]
                 forKey:@"Pennsylvania"];
    
    [signers addObjects:[NSArray arrayWithObjects:
                         person(@"Thomas Mckean", @"http://en.wikipedia.org/wiki/Thomas_McKean"),
                         person(@"John Dickinson", @"http://en.wikipedia.org/wiki/John_Dickinson_(delegate)"),
                         person(@"Nicholas Van Dyke", @"http://en.wikipedia.org/wiki/Nicholas_Van_Dyke_(governor)"),nil]
                 forKey:@"Deleware"];
    
    [signers addObjects:[NSArray arrayWithObjects:
                         person(@"John Hanson", @"http://en.wikipedia.org/wiki/John_Hanson"),
                         person(@"Daniel Carroll", @"http://en.wikipedia.org/wiki/Daniel_Carroll"),nil]
                 forKey:@"Maryland"];
    
    [signers addObjects:[NSArray arrayWithObjects:
                         person(@"Richard Henry Lee", @"http://en.wikipedia.org/wiki/Richard_Henry_Lee"),
                         person(@"John Banister", @"http://en.wikipedia.org/wiki/John_Banister_(lawyer)"),
                         person(@"Thomas Adams", @"http://en.wikipedia.org/wiki/Thomas_Adams_(politician)"),
                         person(@"John Harvie", @"http://en.wikipedia.org/wiki/John_Harvie"),
                         person(@"Francis Lightfoot Lee", @"http://en.wikipedia.org/wiki/Francis_Lightfoot_Lee"),nil]
                 forKey:@"Virginia"];
    
    [signers addObjects:[NSArray arrayWithObjects:
                         person(@"John Penn", @"http://en.wikipedia.org/wiki/John_Penn_(delegate)"),
                         person(@"Cornelius Harnett", @"http://www.google.com/url?q=http://en.wikipedia.org/wiki/Cornelius_Harnett&ei=NkioSYigCYH8tgfN7MHXDw&sa=X&oi=spellmeleon_result&resnum=1&ct=result&cd=1&usg=AFQjCNHDpzuq6d5jPavCHKx2E2VgIvpFGQ"),
                         person(@"John Williams", @"http://en.wikipedia.org/wiki/John_Williams_(delegate)"),nil]
                 forKey:@"North Carolina"];
    
    [signers addObjects:[NSArray arrayWithObjects:
                         person(@"Henry Laurens", @"http://en.wikipedia.org/wiki/Henry_Laurens"),
                         person(@"William Henry Drayton", @"http://en.wikipedia.org/wiki/William_Henry_Drayton"),
                         person(@"Jno Mathews", @"http://en.wikipedia.org/wiki/John_Mathews"),
                         person(@"Richard Hutson", @"http://www.google.com/url?q=http://en.wikipedia.org/wiki/Richard_Hutson"),
                         person(@"Thomas Heyward Jr.", @"http://en.wikipedia.org/wiki/Thomas_Heyward,_Jr."),nil]
                 forKey:@"South Carolina"];
    
    [signers addObjects:[NSArray arrayWithObjects:
                         person(@"George Walton", @"http://en.wikipedia.org/wiki/George_Walton"),
                         person(@"Edward Telfair", @"http://en.wikipedia.org/wiki/Edward_Telfair"),
                         person(@"Edward Langworthy", @"http://en.wikipedia.org/wiki/Edward_Langworthy"),nil]
                 forKey:@"Georgia"];
    
    articlesOfConfederation = 
    [[Constitution constitutionWithCountry:country
                                  preamble:preamble
                                  articles:articles
                                amendments:[NSArray array]
                                conclusion:conclusion
                                   signers:signers] retain];
}


+ (void) initialize {
    if (self == [Model class]) {
        [self setupToughQuestions];
        [self setupConstitutions];
        [self setupDeclarationOfIndependence];
        [self setupArticlesOfConfederation];
        
        sectionTitles = [[NSArray arrayWithObjects:
                          NSLocalizedString(@"Questioning", nil),
                          NSLocalizedString(@"Stops and Arrests", nil),
                          NSLocalizedString(@"Searches and Warrants", nil),
                          NSLocalizedString(@"Additional Information for Non-Citizens", nil),
                          NSLocalizedString(@"Rights at Airports and Other Ports of Entry into the United States", nil),
                          NSLocalizedString(@"Charitable Donations and Religious Practices", nil), nil] retain];
        
        shortSectionTitles = [[NSArray arrayWithObjects:
                               NSLocalizedString(@"Questioning", nil),
                               NSLocalizedString(@"Stops and Arrests", nil),
                               NSLocalizedString(@"Searches and Warrants", nil),
                               NSLocalizedString(@"Info for Non-Citizens", nil),
                               NSLocalizedString(@"Rights at Airports", nil),
                               NSLocalizedString(@"Charitable Donations", nil), nil] retain];
        
        
        preambles = [[NSArray arrayWithObjects:
                      @"",
                      @"",
                      @"",
                      NSLocalizedString(@"In the United States, non-citizens are persons who do not have U.S. "
                                        @"citizenship, including lawful permanent residents, refugees and asylum "
                                        @"seekers, persons who have permission to come to the U.S. for reasons "
                                        @"like work, school or travel, and those without legal immigration status of "
                                        @"any kind. Non-citizens who are in the United States-no matter what "
                                        @"their immigration status-generally have the same constitutional rights "
                                        @"as citizens when law enforcement officers stop, question, arrest, or "
                                        @"search them or their homes. However, there are some special concerns "
                                        @"that apply to non-citizens, so the following rights and responsibilities are "
                                        @"important for non-citizens to know. Non-citizens at the border who are "
                                        @"trying to enter the U.S. do not have all the same rights. See Section 5 for "
                                        @"more information if you are arriving in the U.S.", nil),
                      NSLocalizedString(@"Remember: It is illegal for law enforcement officers to perform any stops, "
                                        @"searches, detentions or removals based solely on your race, national origin, "
                                        @"religion, sex or ethnicity. However, Customs and Border Protection officials "
                                        @"can stop you based on citizenship or travel itinerary at the border and search "
                                        @"all bags.", nil),
                      @"", nil] retain];
        
        otherResources = [[NSArray arrayWithObjects:
                           [NSArray array],
                           [NSArray array],
                           [NSArray array],
                           [NSArray array],
                           [NSArray arrayWithObjects:
                            NSLocalizedString(@"DHS Office for Civil Rights and Civil Liberties\n"
                                              @"http://www.dhs.gov/xabout/structure/editorial_0373.shtm "
                                              @"Investigates abuses of civil rights, civil liberties, and profiling "
                                              @"on the basis of race, ethnicity, or religion by employees and "
                                              @"officials of the Department of Homeland Security. You can submit "
                                              @"your complaint via email to civil.liberties@dhs.gov.", nil),
                            NSLocalizedString(@"U.S. Department of Transportation's Aviation Consumer Protected Division\n"
                                              @"http://airconsumer.ost.dot.gov/problems.htm "
                                              @"Handles complaints against the airline for mistreatment by air "
                                              @"carrier personnel (check-in, gate staff, plane staff, pilot), "
                                              @"including discrimination on the basis of race, ethnicity, religion, "
                                              @"sex, national origin, ancestry, or disability. You can submit a "
                                              @"complaint via email to airconsumer@ost.dot.gov-see the webpage "
                                              @"page for what information to include.", nil),
                            NSLocalizedString(@"U.S. Department of Transportation's Aviation Consumer Protected Division Resource Page\n"
                                              @"http://airconsumer.ost.dot.gov/DiscrimComplaintsContacts.htm "
                                              @"Provides information about how and where to file complaints "
                                              @"about discriminatory treatment by air carrier personnel, federal "
                                              @"security screeners (e.g., personnel screening and searching "
                                              @"passengers and carry-on baggage at airport security checkpoints), "
                                              @"airport personnel (e.g., airport police), FBI, "
                                              @"Immigration and Customs Enforcement (ICE), U.S. Border "
                                              @"Patrol, Customs and Border Protection, and National Guard.", nil), nil],
                           [NSArray array], nil] retain];
        
        sectionLinks = [[NSArray arrayWithObjects:
                         [NSArray array],
                         [NSArray array],
                         [NSArray array],
                         [NSArray array],
                         [NSArray arrayWithObjects:
                          @"http://www.dhs.gov/xabout/structure/editorial_0373.shtm",
                          @"civil.liberties@dhs.gov",
                          @"http://airconsumer.ost.dot.gov/problems.htm",
                          @"airconsumer@ost.dot.gov",
                          @"http://airconsumer.ost.dot.gov/DiscrimComplaintsContacts.htm", nil],
                         [NSArray array], nil] retain];
        
        NSArray* questioningQuestions =
        [NSArray arrayWithObjects:
         NSLocalizedString(@"What kind of law enforcement officers might try to question me?", nil),
         NSLocalizedString(@"Do I have to answer questions asked by law  enforcement officers?", nil),
         NSLocalizedString(@"Are there any exceptions to the general rule that I do not have to answer questions?", nil),
         NSLocalizedString(@"Can I talk to a lawyer before answering questions?", nil),
         NSLocalizedString(@"What if I speak to law enforcement officers anyway?", nil),
         NSLocalizedString(@"What if law enforcement officers threaten me with a grand "
                           @"jury subpoena if I don’t answer their questions?  (A grand jury "
                           @"subpoena is a written order for youabout information you may have.)", nil),
         NSLocalizedString(@"What if I am asked to meet with officers for a "
                           @"“counter-terrorism interview”?", nil), nil];
        
        NSArray* questioningAnswers =
        [NSArray arrayWithObjects:
         NSLocalizedString(@"You could be questioned by a variety of law enforcement "
                           @"officers, including state or local police officers, Joint Terrorism "
                           @"Task Force members, or federal agents from the FBI, "
                           @"Department of Homeland Security (which includes "
                           @"Immigration and Customs Enforcement and the Border "
                           @"Patrol), Drug Enforcement Administration, Naval Criminal "
                           @"Investigative Service, or other agencies.", nil),
         NSLocalizedString(@"No. You have the constitutional right to remain silent. In "
                           @"general, you do not have to talk to law enforcement officers (or "
                           @"anyone else), even if you do not feel free to walk away from the "
                           @"officer, you are arrested, or you are in jail. You cannot be punished "
                           @"for refusing to answer a question. It is a good idea to "
                           @"talk to a lawyer before agreeing to answer questions. In general, "
                           @"only a judge can order you to answer questions. "
                           @"(Non-citizens should see Section 4 for more information on "
                           @"this topic.)", nil),
         NSLocalizedString(@"Yes, there are two limited exceptions. First, in some states, "
                           @"you must provide your name to law enforcement officers if you "
                           @"are stopped and told to identify yourself. But even if you give "
                           @"your name, you are not required to answer other questions. "
                           @"Second, if you are driving and you are pulled over for a traffic "
                           @"violation, the officer can require you to show your license, "
                           @"vehicle registration and proof of insurance (but you do not "
                           @"have to answer questions). (Non-citizens should see Section 4 "
                           @"for more information on this topic.)", nil),
         NSLocalizedString(@"Yes. You have the constitutional right to talk to a lawyer "
                           @"before answering questions, whether or not the police tell you "
                           @"about that right. The lawyer’s job is to protect your rights. "
                           @"Once you say that you want to talk to a lawyer, officers should "
                           @"stop asking you questions. If they continue to ask questions, "
                           @"you still have the right to remain silent. If you do not have a "
                           @"lawyer, you may still tell the officer you want to speak to one before "
                           @"answering questions. If you do have a lawyer, keep his or her business "
                           @"card with you. Show it to the officer, and ask to call your lawyer. "
                           @"Remember to get the name, agency and telephone number of any law "
                           @"enforcement officer who stops or visits you, and give that information to "
                           @"your lawyer.", nil),
         NSLocalizedString(@"Anything you say to a law enforcement officer can be used against you "
                           @"and others. Keep in mind that lying to a government official is a crime "
                           @"but remaining silent until you consult with a lawyer is not. Even if you "
                           @"have already answered some questions, you can refuse to answer other "
                           @"questions until you have a lawyer.", nil),
         NSLocalizedString(@"If a law enforcement officer threatens to get a subpoena, you still do "
                           @"not have to answer the officer’s questions right then and there, and anything "
                           @"you do say can be used against you. The officer may or may not "
                           @"succeed in getting the subpoena. If you receive a subpoena or an officer "
                           @"threatens to get one for you, you should call a lawyer right away. If you "
                           @"are given a subpoena, you must follow the subpoena’s direction about "
                           @"when and where to report to the court, but you can still assert your right "
                           @"not to say anything that could be used against you in a criminal case.", nil),
         NSLocalizedString(@"You have the right to say that you do not want to be interviewed, to "
                           @"have an attorney present, to set the time and place for the interview, to "
                           @"find out the questions they will ask beforehand, and to answer only the "
                           @"questions you feel comfortable answering. If you are taken into custody "
                           @"for any reason, you have the right to remain silent. No matter what, "
                           @"assume that nothing you say is off the record. And remember that it is a "
                           @"criminal offense to knowingly lie to an officer.", nil), nil];
        
        NSArray* stopsAndArrestsQuestions =
        [NSArray arrayWithObjects:
         NSLocalizedString(@"What if law enforcement officers stop me on the street?", nil),
         NSLocalizedString(@"What if law enforcement officers stop me in my car?", nil),
         NSLocalizedString(@"What should I do if law enforcement officers arrest me?", nil),
         NSLocalizedString(@"Do I have to answer questions if I have been arrested?", nil),
         NSLocalizedString(@"What if I am treated badly by law enforcement officers?", nil), nil];
        
        NSArray* stopsAndArrestsAnswers =
        [NSArray arrayWithObjects:
         NSLocalizedString(@"You do not have to answer any questions. You can say, “I do "
                           @"not want to talk to you” and walk away calmly. Or, if you do not "
                           @"feel comfortable doing that, you can ask if you are free to go. If "
                           @"the answer is yes, you can consider just walking away. Do not "
                           @"run from the officer. If the officer says you are not under "
                           @"arrest, but you are not free to go, then you are being detained. "
                           @"Being detained is not the same as being arrested, though an "
                           @"arrest could follow. The police can pat down the outside of "
                           @"your clothing only if they have “reasonable suspicion” (i.e., an "
                           @"objective reason to suspect) that you might be armed and dangerous. "
                           @"If they search any more than this, say clearly, “I do not "
                           @"consent to a search.” If they keep searching anyway, do not "
                           @"physically resist them. You do not need to answer any questions "
                           @"if you are detained or arrested, except that the police may ask "
                           @"for your name once you have been detained, and you can be "
                           @"arrested in some states for refusing to provide it. (Non-citizens "
                           @"should see Section 4 for more information on this topic.)", nil),
         NSLocalizedString(@"Keep your hands where the police can see them. You must "
                           @"show your drivers license, registration and proof of insurance "
                           @"if you are asked for these documents. Officers can also ask "
                           @"you to step outside of the car, and they may separate passengers "
                           @"and drivers from each other to question them and "
                           @"compare their answers, but no one has to answer any questions. "
                           @"The police cannot search your car unless you give them "
                           @"your consent, which you do not have to give, or unless they "
                           @"have “probable cause” to believe (i.e., knowledge of facts sufficient "
                           @"to support a reasonable belief) that criminal activity is "
                           @"likely taking place, that you have been involved in a crime, or "
                           @"that you have evidence of a crime in your car. If you do not "
                           @"want your car searched, clearly state that you do not consent. "
                           @"The officer cannot use your refusal to give consent as a basis "
                           @"for doing a search.", nil),
         NSLocalizedString(@"The officer must advise you of your constitutional rights to "
                           @"remain silent, to an attorney, and to have an attorney appointed "
                           @"if you cannot afford one. You should exercise all these "
                           @"rights, even if the officers don’t tell you about them. Do not tell "
                           @"the police anything except your name. Anything else you say can and will "
                           @"be used against you. Ask to see a lawyer immediately. Within a reasonable "
                           @"amount of time after your arrest or booking you have the right to a "
                           @"phone call. Law enforcement officers may not listen to a call you make "
                           @"to your lawyer, but they can listen to calls you make to other people. You "
                           @"must be taken before a judge as soon as possible-generally within 48 "
                           @"hours of your arrest at the latest.  (See Section 4 for information about "
                           @"arrests for noncriminal immigration violations.)", nil),
         NSLocalizedString(@"No. If you are arrested, you do not have to answer any questions or "
                           @"volunteer any information. Ask for a lawyer right away. Repeat this "
                           @"request to every officer who tries to talk to or question you. You should "
                           @"always talk to a lawyer before you decide to answer any questions.", nil),
         NSLocalizedString(@"Write down the officer’s badge number, name or other identifying "
                           @"information. You have a right to ask the officer for this information. Try to "
                           @"find witnesses and their names and phone numbers. If you are injured, "
                           @"seek medical attention and take pictures of the injuries as soon as you "
                           @"can. Call a lawyer or contact your local ACLU office. You should also "
                           @"make a complaint to the law enforcement office responsible for the "
                           @"treatment.", nil), nil];
        
        
        NSArray* searchesAndWarrantsQuestions =
        [NSArray arrayWithObjects:
         NSLocalizedString(@"Can law enforcement officers search my home or office?", nil),
         NSLocalizedString(@"What are warrants and what should I make sure they say?", nil),
         NSLocalizedString(@"What should I do if officers come to my house?", nil),
         NSLocalizedString(@"Do I have to answer questions if law enforcement officers have a search or arrest warrant?", nil),
         NSLocalizedString(@"What if law enforcement officers do not have a search warrant?", nil),
         NSLocalizedString(@"What if law enforcement officers tell me they will come back "
                           @"with a search warrant if I do not let them in?", nil),
         NSLocalizedString(@"What if law enforcement officers do not have a search "
                           @"warrant, but they insist on searching my home even "
                           @"after I object?", nil), nil];
        
        NSArray* searchesAndWarrantsAnswers =
        [NSArray arrayWithObjects:
         NSLocalizedString(@"Law enforcement officers can search your home only if they "
                           @"have a warrant or your consent. In your absence, the police can "
                           @"search your home based on the consent of your roommate or a "
                           @"guest if the police reasonably believe that person has the "
                           @"authority to consent. Law enforcement officers can search your "
                           @"office only if they have a warrant or the consent of the employer. "
                           @"If your employer consents to a search of your office, law "
                           @"enforcement officers can search your workspace whether you "
                           @"consent or not.", nil),
         NSLocalizedString(@"A warrant is a piece of paper signed by a judge giving law "
                           @"enforcement officers permission to enter a home or other "
                           @"building to do a search or make an arrest. A search warrant "
                           @"allows law enforcement officers to enter the place described in "
                           @"the warrant to look for and take items identified in the warrant. "
                           @"An arrest warrant allows law enforcement officers to take you "
                           @"into custody. An arrest warrant alone does not give law "
                           @"enforcement officers the right to search your home (but they "
                           @"can look in places where you might be hiding and they can take "
                           @"evidence that is in plain sight), and a search warrant alone "
                           @"does not give them the right to arrest you (but they can arrest "
                           @"you if they find enough evidence to justify an arrest). A warrant "
                           @"must contain the judge’s name, your name and address, the "
                           @"date, place to be searched, a description of any items being "
                           @"searched for, and the name of the agency that is conducting "
                           @"the search or arrest. An arrest warrant that does not have your "
                           @"name on it may still be validly used for your arrest if it "
                           @"describes you with enough detail to identify you, and a search "
                           @"warrant that does not have your name on it may still be valid if "
                           @"it gives the correct address and description of the place the "
                           @"officers will be searching. However, the fact that a piece of "
                           @"paper says “warrant” on it does not always mean that it is an "
                           @"arrest or search warrant. A warrant of deportation/removal, "
                           @"for example, is a kind of administrativewarrant and doesnot "
                           @"grant the same authority to enter a home or other building to "
                           @"do a search or make an arrest.", nil),
         NSLocalizedString(@"If law enforcement officers knock on your door, instead of opening "
                           @"the door, ask through the door if they have a warrant. If the answer is "
                           @"no, do not let them into your home and do not answer any questions or "
                           @"say anything other than “I do not want to talk to you.” If the officers say "
                           @"that they do have a warrant, ask the officers to slip it under the door (or "
                           @"show it to you through a peephole, a window in your door, or a door that "
                           @"is open only enough to see the warrant). If you feel you must open the "
                           @"door, then step outside, close the door behind you and ask to see the "
                           @"warrant. Make sure the search warrant contains everything noted above, "
                           @"and tell the officers if they are at the wrong address or if you see some "
                           @"other mistake in the warrant. (And remember that an immigration “warrant "
                           @"of removal/deportation” does not give the officer the authority to "
                           @"enter your home.)  If you tell the officers that the warrant is not complete "
                           @"or not accurate, you should say you do not consent to the search, "
                           @"but you should not interfere if the officers decide to do the search even "
                           @"after you have told them they are mistaken. Call your lawyer as soon as "
                           @"possible. Ask if you are allowed to watch the search; if you are allowed "
                           @"to, you should. Take notes, including names, badge numbers, which "
                           @"agency each officer is from, where they searched and what they took. If "
                           @"others are present, have them act as witnesses to watch carefully what "
                           @"is happening.", nil),
         NSLocalizedString(@"No. Neither a search nor arrest warrant means you have to answer "
                           @"questions.", nil),
         NSLocalizedString(@"You do not have to let law enforcement officers search your home, "
                           @"and you do not have to answer their questions. Law enforcement officers "
                           @"cannot get a warrant based on your refusal, nor can they punish you for "
                           @"refusing to give consent.", nil),
         NSLocalizedString(@"You can still tell them that you do not consent to the search and that "
                           @"they need to get a warrant. The officers may or may not succeed in getting "
                           @"a warrant if they follow through and ask the court for one, but once "
                           @"you give your consent, they do not need to try to get the court’s permission "
                           @"to do the search.", nil),
         NSLocalizedString(@"You should not interfere with the search in any way because "
                           @"you could get arrested. But you should say clearly that you "
                           @"have not given your consent and that the search is against your "
                           @"wishes. If someone is there with you, ask him or her to witness "
                           @"that you are not giving permission for the search. Call your "
                           @"lawyer as soon as possible. Take note of the names and badge "
                           @"numbers of the searching officers", nil), nil];
        
        
        NSArray* nonCitizensQuestions =
        [NSArray arrayWithObjects:
         NSLocalizedString(@"What types of law enforcement officers may try to question me?", nil),
         NSLocalizedString(@"What can I do if law enforcement officers want to question me?", nil),
         NSLocalizedString(@"Do I have to answer questions about whether I am a U.S. citizen, "
                           @"where I was born, where I live, where I am from, or other "
                           @"questions about my immigration status?", nil),
         NSLocalizedString(@"Do I have to show officers my immigration documents?", nil),
         NSLocalizedString(@"What should I do if there is an immigration raid where I work?", nil),
         NSLocalizedString(@"What can I do if immigration officers are arresting me and I "
                           @"have children in my care or my children need to be picked up "
                           @"and taken care of?", nil),
         NSLocalizedString(@"What should I do if immigration officers arrest me?", nil),
         NSLocalizedString(@"Do I have the right to talk to a lawyer before answering any "
                           @"law enforcement officers’ questions or signing any immigration "
                           @"papers?", nil),
         NSLocalizedString(@"If I am arrested for immigration violations, do I have "
                           @"the right to a hearing before an immigration judge to "
                           @"defend myself against deportation charges?", nil),
         NSLocalizedString(@"Can I be detained while my immigration case is happening?", nil),
         NSLocalizedString(@"Can I call my consulate if I am arrested?", nil),
         NSLocalizedString(@"What happens if I give up my right to a hearing or "
                           @"leave the U.S. before the hearing is over?", nil),
         NSLocalizedString(@"What should I do if I want to contact immigration officials?", nil),
         NSLocalizedString(@"What if I am charged with a crime?", nil), nil];
        
        NSArray* nonCitizensAnswers =
        [NSArray arrayWithObjects:
         NSLocalizedString(@"Different kinds of law enforcement officers might question you or ask "
                           @"you to agree to an interview where they would ask questions about your "
                           @"background, immigration status, relatives, colleagues and other topics. "
                           @"You may encounter the full range of law enforcement officers listed in "
                           @"Section 1.", nil),
         NSLocalizedString(@"You have the same right to be silent that U.S. citizens have, so the "
                           @"general rule is that you do not have to answer any questions that a law "
                           @"enforcement officer asks you. However, there are exceptions to this at "
                           @"ports of entry, such as airports and borders (see Section 5).", nil),
         NSLocalizedString(@"You do not have to answer any of the above questions if you do not "
                           @"want to answer them. But do not falsely claim U.S. citizenship. It is "
                           @"almost always a good idea to speak with a lawyer before you answer "
                           @"questions about your immigration status. Immigration law is very "
                           @"complicated, and you could have a problem without realizing it. A lawyer can "
                           @"help protect your rights, advise you, and help you avoid a problem. "
                           @"Always remember that even if you have answered some questions, you "
                           @"can still decide you do not want to answer any more questions. "
                           @"For “nonimmigrants” (a “nonimmigrant” is a non-citizen who is "
                           @"authorized to be in the U.S. for a particular reason or activity, usually for "
                           @"a limited period of time, such as a person with a tourist, student, or "
                           @"work visa), there is one limited exception to the rule that non-citizens "
                           @"who are already in the U.S. do not have to answer law enforcement "
                           @"officers’ questions: immigration officers can require "
                           @"nonimmigrants to provide information related to their immigration "
                           @"status. However, even if you are a nonimmigrant, you can still "
                           @"say that you would like to have your lawyer with you before you "
                           @"answer questions, and you have the right to stay silent if your "
                           @"answer to a question could be used against you in a criminal case.", nil),
         NSLocalizedString(@"The law requires non-citizens who are 18 or older and who "
                           @"have been issued valid U.S. immigration documents to carry "
                           @"those documents with them at all times. (These immigration "
                           @"documents are often called “alien registration” documents. "
                           @"The type you need to carry depends on your immigration status. "
                           @"Some examples include an unexpired permanent resident "
                           @"card (“green card”), I-94, Employment Authorization Document "
                           @"(EAD), or border crossing card.)  Failure to comply carry these "
                           @"documents can be a misdemeanor crime. "
                           @"If you have your valid U.S. immigration documents and "
                           @"you are asked for them, then it is usually a good idea to show "
                           @"them to the officer because it is possible that you will be "
                           @"arrested if you do not do so. Keep a copy of your documents in "
                           @"a safe place and apply for a replacement immediately if you "
                           @"lose your documents or if they are going to expire. If you are "
                           @"arrested because you do not have your U.S. immigration documents "
                           @"with you, but you have them elsewhere, ask a friend or "
                           @"family member (preferably one who has valid immigration status) "
                           @"to bring them to you. "
                           @"It is never a good idea to show an officer fake immigration "
                           @"documents or to pretend that someone else’s immigration "
                           @"documents are yours. If you are undocumented and therefore "
                           @"do not have valid U.S. immigration documents, you can decide "
                           @"not to answer questions about your citizenship or immigration "
                           @"status or whether you have documents. If you tell an immigration "
                           @"officer that you are not a U.S. citizen and you then cannot "
                           @"produce valid U.S. immigration documents, there is a very good "
                           @"chance you will be arrested.", nil),
         NSLocalizedString(@"If your workplace is raided, it may not be clear to you "
                           @"whether you are free to leave. Either way, you have the right to "
                           @"remain silent-you do not have to answer questions about your "
                           @"citizenship, immigration status or anything else. If you do "
                           @"answer questions and you say that you are not a U.S. citizen, you will be "
                           @"expected to produce immigration documents showing your immigration "
                           @"status. If you try to run away, the immigration officers will assume that "
                           @"you are in the U.S. illegally and you will likely be arrested. The safer "
                           @"course is to continue with your work or calmly ask if you may leave, and "
                           @"to not answer any questions you do not want to answer. (If you are a "
                           @"“nonimmigrant,” see above.)", nil),
         NSLocalizedString(@"If you have children with you when you are arrested, ask the officers "
                           @"if you can call a family member or friend to come take care of them "
                           @"before the officers take you away. If you are arrested when your children "
                           @"are at school or elsewhere, call a friend or family member as soon as "
                           @"possible so that a responsible adult will be able to take care of them.", nil),
         NSLocalizedString(@"Assert your rights.Non-citizens have rights that are important for "
                           @"their immigration cases. You do not have to answer questions. You can "
                           @"tell the officer you want to speak with a lawyer. You do not have to sign "
                           @"anything giving up your rights, and should never sign anything without "
                           @"reading, understanding and knowing the consequences of signing it. If "
                           @"you do sign a waiver, immigration agents could try to deport you before "
                           @"you see a lawyer or a judge. The immigration laws are hard to understand. "
                           @"There may be options for you that the immigration officers will "
                           @"not explain to you. You should talk to a lawyer before signing anything or "
                           @"making a decision about your situation. If possible, carry with you the "
                           @"name and telephone number of a lawyer who will take your calls.", nil),
         NSLocalizedString(@"Yes. You have the right to call a lawyer or your family if you are "
                           @"detained, and you have the right to be visited by a lawyer in detention. "
                           @"You have the right to have your attorney with you at any hearing before "
                           @"an immigration judge. You do not have the right to a government-"
                           @"appointed attorney for immigration proceedings, but immigration "
                           @"officials must give you a list of free or low-cost legal service providers. "
                           @"You have the right to hire your own immigration attorney.", nil),
         NSLocalizedString(@"Yes. In most cases only an immigration judge can order you "
                           @"deported. But if you waive your rights, sign something called a "
                           @"“Stipulated Removal Order,” or take “voluntary departure,” "
                           @"agreeing to leave the country, you could be deported without a "
                           @"hearing. There are some reasons why a person might not have "
                           @"a right to see an immigration judge, but even if you are told "
                           @"that this is your situation, you should speak with a lawyer "
                           @"immediately-immigration officers do not always know or tell "
                           @"you about exceptions that may apply to you; and you could have "
                           @"a right that you do not know about. Also, it is very important "
                           @"that you tell the officer (and contact a lawyer) immediately if "
                           @"you fear persecution or torture in your home country-you have "
                           @"additional rights if you have this fear, and you may be able to "
                           @"win the right to stay here.", nil),
         NSLocalizedString(@"In many cases, you will be detained, but most people are "
                           @"eligible to be released on bond or other reporting conditions. If "
                           @"you are denied release after you are arrested for an immigration "
                           @"violation, ask for a bond hearing before an immigration "
                           @"judge. In many cases, an immigration judge can order that you "
                           @"be releasedor that your bond be lowered.", nil),
         NSLocalizedString(@"Yes. Non-citizens arrested in the U.S. have the right to call "
                           @"their consulate or to have the law enforcement officer tell the "
                           @"consulate of your arrest. Law enforcement must let your consulate "
                           @"visit or speak with you if consular officials decide to do so. "
                           @"Your consulate might help you find a lawyer or offer other help.", nil),
         NSLocalizedString(@"If you are deported, you could lose your eligibility for certain "
                           @"immigration benefits, and you could be barred from returning "
                           @"to the U.S. for a number of years or, in some cases, permanently. "
                           @"The same is true if you do not go to your hearing and "
                           @"the immigration judge rules against you in your absence. If the "
                           @"government allows you to do “voluntary departure,” you may "
                           @"avoid some of the problems that come with having a deportation "
                           @"order and you may have a better chance at having a future opportunity "
                           @"to return to the U.S., but you should discuss your case with a lawyer "
                           @"because even with voluntary departure, there can be bars to returning, "
                           @"and you may be eligible for relief in immigration court. You should "
                           @"always talk to an immigration lawyer before you decide to give up your "
                           @"right to a hearing.", nil),
         NSLocalizedString(@"Always try to talk to a lawyer before contacting immigration officials, "
                           @"even on the phone. Many immigration officials view “enforcement” as "
                           @"their primary job and will not explain all of your options to you, and you "
                           @"could have a problem with your immigration status without knowing it.", nil),
         NSLocalizedString(@"Criminal convictions can make you deportable. You should always "
                           @"speak with your lawyer about the effect that a conviction or plea could "
                           @"have on your immigration status. Do not agree to a plea bargain without "
                           @"understanding if it could make you deportable or ineligible for relief or "
                           @"for citizenship.", nil), nil];
        
        NSArray* portsOfEntryQuestions =
        [NSArray arrayWithObjects:
         NSLocalizedString(@"What types of officers could I encounter at the airport and at the border?", nil),
         NSLocalizedString(@"If I am entering the U.S. with valid travel papers, can "
                           @"law enforcement officers stop and search me?", nil),
         NSLocalizedString(@"Can law enforcement officers ask questions about my "
                           @"immigration status?", nil),
         NSLocalizedString(@"If I am selected for a longer interview when I am "
                           @"coming into the United States, what can I do?", nil),
         NSLocalizedString(@"Can law enforcement officers search my laptop files?  If they "
                           @"do, can they make copies of the files, or information from my "
                           @"address book, papers, or cell phone contacts?", nil),
         NSLocalizedString(@"Can my bags or I be searched after going through metal "
                           @"detectors with no problem or after security sees that my bags do "
                           @"not contain a weapon?", nil),
         NSLocalizedString(@"What if I wear a religious head covering and I am selected by "
                           @"airport security officials for additional screening?", nil),
         NSLocalizedString(@"What if I am selected for a strip search?", nil),
         NSLocalizedString(@"If I am on an airplane, can an airline employee interrogate me or ask me to get off the plane?", nil),
         NSLocalizedString(@"What do I do if I am questioned by law enforcement "
                           @"officers every time I travel by air and I believe I am on a "
                           @"“no-fly” or other “national security” list?", nil),
         NSLocalizedString(@"If I believe that customs or airport agents or airline "
                           @"employees singled me out because of my race, ethnicity, "
                           @"or religion or that I was mistreated in other ways, what "
                           @"information should I record during and after the incident?", nil), nil];
        
        NSArray* portsOfEntryAnswers =
        [NSArray arrayWithObjects:
         NSLocalizedString(@"You may encounter any of the full range of law enforcement "
                           @"officers listed above in Section 1. In particular, at airports and "
                           @"at the border you are likely to encounter customs agents, "
                           @"immigration officers, and Transportation and Safety "
                           @"Administration (TSA) officers.", nil),
         NSLocalizedString(@"Yes. Customs officers have the right to stop, detain and "
                           @"search any person or item. But officers cannot select you for a "
                           @"personal search based on your race, gender, religious or ethnic "
                           @"background. If you are a non-citizen, you should carry your "
                           @"green card or other valid immigration status documents at all "
                           @"times.", nil),
         NSLocalizedString(@"Yes. At airports, law enforcement officers have the power to "
                           @"determine whether or not you have the right or permission to "
                           @"enter or return to the U.S.", nil),
         NSLocalizedString(@"If you are a U.S. citizen, you have the right to have an attorney "
                           @"present for any questioning. If you are a non-citizen, you "
                           @"generally do not have the right to an attorney when you have "
                           @"arrived at an airport or another port of entry and an immigration "
                           @"officer is inspecting you to decide whether or not you will "
                           @"be admitted. However, you do have the right to an attorney if "
                           @"the questions relate to anything other than your immigration "
                           @"status. You can ask an officer if he or she will allow you to "
                           @"answer extended questioning at a later time, but the request may or may "
                           @"not be granted. If you are not a U.S. citizen and an officer says you "
                           @"cannot come into the U.S., but you fear that you will be persecuted or "
                           @"tortured if sent back to the country you came from, tell the officer about "
                           @"your fear and say that you want asylum.", nil),
         NSLocalizedString(@"This issue is contested right now. Generally, law enforcement officers "
                           @"can search your laptop files and make copies of information contained in "
                           @"the files. If such a search occurs, you should write down the name, "
                           @"badge number, and agency of the person who conducted the search. You "
                           @"should also file a complaint with that agency.", nil),
         NSLocalizedString(@"Yes. Even if the initial screen of your bags reveals nothing suspicious, "
                           @"the screeners have the authority to conduct a further search of you or "
                           @"your bags.", nil),
         NSLocalizedString(@"You have the right to wear religious head coverings. You should assert "
                           @"your right to wear your religious head covering if asked to remove it. The "
                           @"current policy (which is subject to change) relating to airport screeners "
                           @"and requiring removal of religious head coverings, such as a turban or "
                           @"hijab, is that if an alarm goes off when you walk through the metal "
                           @"detector the TSA officer may then use a hand-wand to determine if the "
                           @"alarm is coming from your religious head covering. If the alarm is coming "
                           @"from your religious head covering the TSA officer may want to "
                           @"pat-down or have you remove your religious head covering. You have the "
                           @"right to request that this pat-down or removal occur in a private area. If "
                           @"no alarm goes off when you go through the metal detector the TSA officer "
                           @"may nonetheless determine that additional screening is required for "
                           @"non-metallic items. Additional screening cannot be required on a "
                           @"discriminatory basis (because of race, gender, religion, national origin or "
                           @"ancestry). The TSA officer will ask you if he or she can pat-down your "
                           @"religious head covering. If you do not want the TSA officer to touch your "
                           @"religious head covering you must refuse and say that you would prefer to "
                           @"pat-down your own religious head covering. You will then be taken aside "
                           @"and a TSA officer will supervise you as you pat-down your religious head "
                           @"covering. After the pat-down the TSA officer will rub your "
                           @"hands with a small cotton cloth and place it in a machine to "
                           @"test for chemical residue. If you pass this chemical residue "
                           @"test, you should be allowed to proceed to your flight. If the TSA "
                           @"officer insists on the removal of your religious head covering "
                           @"you have a right to ask that it be done in a private area.", nil),
         NSLocalizedString(@"A strip search at the border is not a routine search and "
                           @"must be supported by “reasonable suspicion,” and must be "
                           @"done in a private area.", nil),
         NSLocalizedString(@"The pilot of an airplane has the right to refuse to fly a "
                           @"passenger if he or she believes the passenger is a threat to the "
                           @"safety of the flight. The pilot’s decision must be reasonable and "
                           @"based on observations of you, not stereotypes.", nil),
         NSLocalizedString(@"If you believe you are mistakenly on a list you should contact "
                           @"the Transportation Security Administration and file an inquiry "
                           @"using the Traveler Redress Inquiry Process. The form is available at "
                           @"http://www.tsa.gov/travelers/customer/redress/index.shtm. "
                           @"You should also fill out a complaint form with the ACLU at "
                           @"http://www.aclu.org/noflycomplaint. If you think there may be "
                           @"some legitimate reason for why you have been placed on a list, "
                           @"you should seek the advice of an attorney.", nil),
         NSLocalizedString(@"It is important to record the details of the incident while they "
                           @"are fresh in your mind. When documenting the sequence of "
                           @"events, be sure to note the airport, airline, flight number, the "
                           @"names and badge numbers of any law enforcement officers "
                           @"involved, information on any airline or airport personnel "
                           @"involved, questions asked in any interrogation, stated reason "
                           @"for treatment, types of searches conducted, and length and conditions of "
                           @"detention. When possible, it is helpful to have a witness to the incident. If "
                           @"you have been mistreated or singled out at the airport based on your "
                           @"race, ethnicity or religion, please fill out the Passenger Profiling "
                           @"Complaint Form on the ACLU’s web site at http://www.aclu.org/airlineprofiling, "
                           @"and file a complaint with the U.S. Department of "
                           @"Transportation at "
                           @"http://airconsumer.ost.dot.gov/DiscrimComplaintsContacts.htm.", nil), nil];
        
        NSArray* portsOfEntryLinks =
        [NSArray arrayWithObjects:
         [NSArray array],
         [NSArray array],
         [NSArray array],
         [NSArray array],
         [NSArray array],
         [NSArray array],
         [NSArray array],
         [NSArray array],
         [NSArray array],
         [NSArray arrayWithObjects:@"http://www.tsa.gov/travelers/customer/redress/index.shtm", @"http://www.aclu.org/noflycomplaint", nil],
         [NSArray arrayWithObjects:@"http://www.aclu.org/airlineprofiling", @"http://airconsumer.ost.dot.gov/DiscrimComplaintsContacts.htm", nil],
         nil];
        
        NSArray* charitableDonationsQuestions =
        [NSArray arrayWithObjects:
         NSLocalizedString(@"Can I give to a charity organization without becoming a "
                           @"terror suspect?", nil),
         NSLocalizedString(@"Is it safe for me to practice my religion in religious "
                           @"institutions or public places?", nil),
         NSLocalizedString(@"What else can I do to be prepared?", nil), nil];
        
        NSArray* charitableDonationsAnswers =
        [NSArray arrayWithObjects:
         NSLocalizedString(@"Yes. You should continue to give money to the causes you believe "
                           @"in, but you should be careful in choosing which charities to support."
                           @"For helpful tips, see Muslim Advocates’ guide on charitable giving: "
                           @"http://www.muslimadvocates.org/documents/safe_donating.html.", nil),
         NSLocalizedString(@"Yes. Worshipping as you want is your constitutional right. You "
                           @"have the right to go to a place of worship, attend and hear sermons "
                           @"and religious lectures, participate in community activities, and pray "
                           @"in public. While there have been news stories recently about people "
                           @"being unfairly singled out for doing these things, the law is on your "
                           @"side to protect you.", nil),
         NSLocalizedString(@"You should keep informed about issues that matter to you by "
                           @"going to the library, reading the news, surfing the internet, and "
                           @"speaking out about what is important to you. In case of emergency, "
                           @"you should have a family plan-the number of a good friend or "
                           @"relative that anyone in the family can call if they need help, as well "
                           @"as the number of an attorney. If you are a non-citizen, remember to "
                           @"carry your immigration documents with you.", nil), nil];
        
        NSArray* charitableDonationsLinks =
        [NSArray arrayWithObjects:
         [NSArray arrayWithObjects:@"http://www.muslimadvocates.org/documents/safe_donating.html", nil],
         [NSArray array],
         [NSArray array], nil];
        
        questions = [[NSArray arrayWithObjects:
                      questioningQuestions,
                      stopsAndArrestsQuestions,
                      searchesAndWarrantsQuestions,
                      nonCitizensQuestions,
                      portsOfEntryQuestions,
                      charitableDonationsQuestions, nil] retain];
        answers = [[NSArray arrayWithObjects:
                    questioningAnswers,
                    stopsAndArrestsAnswers,
                    searchesAndWarrantsAnswers,
                    nonCitizensAnswers,
                    portsOfEntryAnswers,
                    charitableDonationsAnswers, nil] retain];
        
        links = [[NSArray arrayWithObjects:
                  [NSArray array],
                  [NSArray array],
                  [NSArray array],
                  [NSArray array],
                  portsOfEntryLinks,
                  charitableDonationsLinks, nil] retain];
    }
}


@synthesize rssCache;

- (void) dealloc {
    self.rssCache = nil;
    [super dealloc];
}


- (void) updateCaches:(NSNumber*) number {
    NSInteger value = [number integerValue];
    
    switch (value) {
        case 0:
            [rssCache update];
            break;
            
        default:
            return;
    }
    
    [self performSelector:@selector(updateCaches:)
               withObject:[NSNumber numberWithInt:value + 1]
               afterDelay:1];
}


- (id) init {
    if (self = [super init]) {
        self.rssCache = [RSSCache cacheWithModel:self];
        [self updateCaches:[NSNumber numberWithInt:0]];
    }
    
    return self;
}


- (NSArray*) sectionTitles {
    return sectionTitles;
}


- (NSArray*) shortSectionTitles {
    return shortSectionTitles;
}


- (NSString*) shortSectionTitleForSectionTitle:(NSString*) sectionTitle {
    return [shortSectionTitles objectAtIndex:[sectionTitles indexOfObject:sectionTitle]];
}


- (NSString*) preambleForSectionTitle:(NSString*) sectionTitle {
    return [preambles objectAtIndex:[sectionTitles indexOfObject:sectionTitle]];
}


- (NSArray*) questionsForSectionTitle:(NSString*) sectionTitle {
    return [questions objectAtIndex:[sectionTitles indexOfObject:sectionTitle]];
}


- (NSArray*) otherResourcesForSectionTitle:(NSString*) sectionTitle {
    return [otherResources objectAtIndex:[sectionTitles indexOfObject:sectionTitle]];
}


- (NSArray*) answersForSectionTitle:(NSString*) sectionTitle {
    return [answers objectAtIndex:[sectionTitles indexOfObject:sectionTitle]];
}


- (NSString*) answerForQuestion:(NSString*) question withSectionTitle:(NSString*) sectionTitle {
    NSArray* questions = [self questionsForSectionTitle:sectionTitle];
    NSArray* specificAnswers = [self answersForSectionTitle:sectionTitle];
    
    return [specificAnswers objectAtIndex:[questions indexOfObject:question]];
}


NSInteger compareLinks(id link1, id link2, void* context) {
    NSRange range1 = [link1 rangeOfString:@"@"];
    NSRange range2 = [link2 rangeOfString:@"@"];
    
    if (range1.length > 0 && range2.length == 0) {
        return NSOrderedDescending;
    } else if (range2.length > 0 && range1.length == 0) {
        return NSOrderedAscending;
    } else {
        return [link1 compare:link2];
    }
}


- (NSArray*) linksForSectionTitle:(NSString*) sectionTitle {
    NSArray* result = [sectionLinks objectAtIndex:[sectionTitles indexOfObject:sectionTitle]];
    return [result sortedArrayUsingFunction:compareLinks context:NULL];
}


- (NSArray*) linksForQuestion:(NSString*) question withSectionTitle:(NSString*) sectionTitle {
    NSArray* questions = [self questionsForSectionTitle:sectionTitle];
    NSArray* specificLinks = [links objectAtIndex:[sectionTitles indexOfObject:sectionTitle]];
    if (specificLinks.count == 0) {
        return [NSArray array];
    }
    
    NSArray* result = [specificLinks objectAtIndex:[questions indexOfObject:question]];
    return [result sortedArrayUsingFunction:compareLinks context:NULL];
}


- (NSArray*) toughQuestions {
    return toughQuestions;
}


- (NSString*) answerForToughQuestion:(NSString*) question {
    return [toughAnswers objectAtIndex:[toughQuestions indexOfObject:question]];
}


- (NSInteger) greatestHitsSortIndex {
    return 0;
}


- (void) setGreatestHitsSortIndex:(NSInteger) index {
    
}


- (NSString*) feedbackUrl {
    NSString* body = [NSString stringWithFormat:@"\n\nVersion: %@\nCountry: %@\nLanguage: %@",
                      currentVersion,
                      [LocaleUtilities englishCountry],
                      [LocaleUtilities englishLanguage]];
    
    NSString* subject = @"Your%20Rights%20Feedback";
    
    NSString* encodedBody = [Utilities stringByAddingPercentEscapes:body];
    NSString* result = [NSString stringWithFormat:@"mailto:cyrus.najmabadi@gmail.com?subject=%@&body=%@", subject, encodedBody];
    return result;
}


- (Constitution*) unitedStatesConstitution {
    return unitedStatesConstitution;
}


- (Constitution*) articlesOfConfederation {
    return articlesOfConfederation;
}


- (Constitution*) federalistPapers {
    return federalistPapers;
}


- (DeclarationOfIndependence*) declarationOfIndependence {
    return declarationOfIndependence;
}

@end