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

static Constitution* federalistPapers;
static DeclarationOfIndependence* declarationOfIndependence;

+ (NSString*) version {
    return currentVersion;
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


+ (void) initialize {
    if (self == [Model class]) {
        [self setupToughQuestions];
        [self setupDeclarationOfIndependence];

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


- (Constitution*) federalistPapers {
    return federalistPapers;
}


- (DeclarationOfIndependence*) declarationOfIndependence {
    return declarationOfIndependence;
}

@end